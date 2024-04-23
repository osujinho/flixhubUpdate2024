//
//  SeriesDetailViewModel.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/14/24.
//

import Foundation

@MainActor
class SeriesDetailViewModel: ObservableObject {
    
    @Published private(set) var tmdbSeriesDetail: TmdbSeriesResponse?
    @Published private(set) var omdbSeriesDetail: OmdbSeriesResponse?
    @Published private(set) var similarSeries: [SeriesCollection] = []
    @Published private(set) var recommendedSeries: [SeriesCollection] = []
    
    @Published private(set) var seriesDetailAlertOption: SeriesDetailAlert = .loadingTmdbDetail(message: "")
    @Published var hasError: Bool = false
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isLoadingSimilar: Bool = false
    @Published private(set) var isLoadingRecommended: Bool = false
    
    @Published var seriesDetailOptions: SeriesDetailOption? = .about
    
    // For Trailer
    @Published var playTrailer: Bool = false
    @Published var showNoTrailerAlert: Bool = false
    
    var service: SeriesServiceable
    var seriesId: Int
    
    // MARK: - Similar movies
    private var similarPagination: PaginationManager = PaginationManager()
    private var recommendedPagination: PaginationManager = PaginationManager()
    
    var trailerKey: String {
        if let video = tmdbSeriesDetail?.videos?.first(where: {
            $0.type?.lowercased() == "trailer"
        }) {
            return video.key
        }
        return ""
    }
    
    init(service: SeriesServiceable, seriesId: Int) {
        self.service = service
        self.seriesId = seriesId
        
        Task {
            await loadCompleteSeriesDetail(seriesId: seriesId)
        }
    }
    
    // MARK: - Methods that can be called outside viewModel

    func loadMoreSimilarSeriesIfNeeded(currentSeries series: SeriesCollection?) async {
        
        await similarPagination.loadMoreIfNeeded(currentItem: series, items: similarSeries) { [weak self] in
            
            guard let self = self else { return }
            
            self.resetError()
            let newMovies = await self.fetchMoreSimilarSeries()
            self.similarSeries.append(contentsOf: newMovies ?? [])
        }
    }
    
    func loadMoreRecommendedSeriesIfNeeded(currentSeries series: SeriesCollection?) async {
        
        await recommendedPagination.loadMoreIfNeeded(currentItem: series, items: recommendedSeries) { [weak self] in
            
            guard let self = self else { return }
            
            self.resetError()
            let newMovies = await self.fetchMoreRecommendedSeries()
            self.recommendedSeries.append(contentsOf: newMovies ?? [])
        }
    }
    
    func loadCompleteSeriesDetail(seriesId: Int) async {
        
        guard !isLoading else { return }
        self.isLoading = true
        resetError()
        
        async let seriesTask = loadTmdbDetail(seriesId: seriesId)
        async let similarTask = fetchMoreSimilarSeries()
        async let recommendedTask = fetchMoreRecommendedSeries()
        
        let (currentSeries, currentSimilar, currentRecommended) = await (seriesTask, similarTask, recommendedTask)
        
        self.tmdbSeriesDetail = currentSeries
        self.similarSeries = currentSimilar ?? []
        self.recommendedSeries = currentRecommended ?? []
        
        if let imdbId = currentSeries?.imdbId {
            async let omdbTask = loadOmdbDetail(imdbId: imdbId)
            self.omdbSeriesDetail = await omdbTask
        }
        
        self.isLoading = false
    }
    
    // MARK: - Load details
    private func loadTmdbDetail(seriesId: Int) async -> TmdbSeriesResponse? {
        
        do {
            let response: TmdbSeriesResponse = try await service.getSeriesDetail(id: seriesId)
            return response
            
        } catch {
            let message = RequestError.getMessage(error: error)
            throwError(alertType: .loadingTmdbDetail(message: message))
            return nil
        }
    }
    
    private func loadOmdbDetail(imdbId: String) async -> OmdbSeriesResponse? {
        
        do {
            let response: OmdbSeriesResponse = try await service.getOmdbSeriesDetail(id: imdbId)
            return response
            
        } catch {
            let message = RequestError.getMessage(error: error)
            throwError(alertType: .loadingOmdbDetail(message: message))
            return nil
        }
    }
    
    // MARK: - Similar and recommended Series
    
    private func fetchMoreSimilarSeries() async -> [SeriesCollection]? {
        
        guard !isLoadingSimilar && similarPagination.canLoadMore else { return nil }
        self.isLoadingSimilar = true
        
        do {
            let response: PageResultsResponse = try await service.getSimilarSeries(id: seriesId, page: similarPagination.currentPage)
            
            self.isLoadingSimilar = false
            
            return similarPagination.updateResults(response.results, totalPages: response.totalPages, resultContainerIsEmpty: similarSeries.isEmpty)
            
        } catch {
            let message = RequestError.getMessage(error: error)
            self.isLoadingSimilar = false
            throwError(alertType: .loadingSimilar(message: message))
            return nil
        }
    }
    
    private func fetchMoreRecommendedSeries() async -> [SeriesCollection]? {
        
        guard !isLoadingRecommended && recommendedPagination.canLoadMore else { return nil }
        self.isLoadingRecommended = true
        
        do {
            let response: PageResultsResponse = try await service.getRecommendedSeries(id: seriesId, page: recommendedPagination.currentPage)
            
            isLoadingRecommended = false
            return recommendedPagination.updateResults(response.results, totalPages: response.totalPages, resultContainerIsEmpty: recommendedSeries.isEmpty)
            
        } catch {
            let message = RequestError.getMessage(error: error)
            self.isLoadingRecommended = false
            throwError(alertType: .loadingRecommended(message: message))
            return nil
        }
    }
    
    func checkForTrailer() {
        if !trailerKey.isEmpty {
            self.playTrailer = true
        } else {
            showNoTrailerAlert.toggle()
        }
    }
    
    private func throwError(alertType: SeriesDetailAlert) {
        self.seriesDetailAlertOption = alertType
        self.hasError = true
    }
    
    func resetError() {
        seriesDetailAlertOption = .loadingTmdbDetail(message: "")
        hasError = false
    }
}
