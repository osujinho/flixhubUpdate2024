//
//  MovieDetailViewModel.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/10/24.
//

import Foundation

@MainActor 
class MovieDetailViewModel: ObservableObject {
    
    @Published private(set) var tmdbMovieDetail: TmdbMovieResponse?
    @Published private(set) var omdbMovieDetail: OmdbMovieResponse?
    @Published private(set) var similarMovies: [MovieCollection] = []
    @Published private(set) var recommendedMovies: [MovieCollection] = []
    
    @Published private(set) var movieDetailAlertOption: MovieDetailAlert = .loadingTmdbDetail(message: "")
    @Published var hasError: Bool = false
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isLoadingSimilar: Bool = false
    @Published private(set) var isLoadingRecommended: Bool = false
    
    @Published var movieDetailOptions: MovieDetailOptions? = .about
    
    // For Trailer
    @Published var playTrailer: Bool = false
    @Published var showNoTrailerAlert: Bool = false
    
    var service: MovieServiceable
    var movieId: Int
    
    // MARK: - Similar movies
    private var similarPagination: PaginationManager = PaginationManager()
    private var recommendedPagination: PaginationManager = PaginationManager()
    
    var trailerKey: String {
        if let video = tmdbMovieDetail?.videos?.first(where: {
            $0.type?.lowercased() == "trailer"
        }) {
            return video.key
        }
        return ""
    }
    
    init(service: MovieServiceable, movieId: Int) {
        self.service = service
        self.movieId = movieId
        
        Task {
            await loadAllMovies(movieId: movieId)
        }
    }
    
    // MARK: - Methods that can be called outside viewModel

    func loadMoreSimilarMovieIfNeeded(currentMovie movie: MovieCollection?) async {
        
        guard !isLoadingSimilar else { return }
        
        await similarPagination.loadMoreIfNeeded(currentItem: movie, items: similarMovies) { [weak self] in
            
            guard let self = self else { return }
            
            self.resetError()
            self.isLoadingSimilar = true
            
            let newMovies = await self.fetchSimilarMovies()
            self.similarMovies.append(contentsOf: newMovies ?? [])
            self.isLoadingSimilar = false
        }
    }
    
    func loadMoreRecommendedMovieIfNeeded(currentMovie movie: MovieCollection?) async {
        
        guard !isLoadingRecommended else { return }
        
        await recommendedPagination.loadMoreIfNeeded(currentItem: movie, items: recommendedMovies) { [weak self] in
            
            guard let self = self else { return }
            
            self.resetError()
            self.isLoadingRecommended = true
            
            let newMovies = await self.fetchRecommendedMovies()
            self.recommendedMovies.append(contentsOf: newMovies ?? [])
            self.isLoadingRecommended = false
        }
    }
    
    func loadAllMovies(movieId: Int) async {
        
        guard !isLoading else { return }
        self.isLoading = true
        resetError()
        
        async let movieTask = loadTmdbDetail(movieId: movieId)
        async let similarTask = fetchSimilarMovies()
        async let recommendedTask = fetchRecommendedMovies()
        
        let (currentMovie, currentSimilar, currentRecommended) = await (movieTask, similarTask, recommendedTask)
        
        self.tmdbMovieDetail = currentMovie
        self.similarMovies = currentSimilar ?? []
        self.recommendedMovies = currentRecommended ?? []
        
        if let imdbId = currentMovie?.imdbId {
            async let omdbTask = loadOmdbDetail(imdbId: imdbId)
            self.omdbMovieDetail = await omdbTask
        }
        
        self.isLoading = false
    }
    
    // MARK: - Load details
    private func loadTmdbDetail(movieId: Int) async -> TmdbMovieResponse? {
        
        do {
            let response: TmdbMovieResponse = try await service.getTmdbMovieDetail(id: movieId)
            return response
            
        } catch {
            let message = RequestError.getMessage(error: error)
            throwError(alertType: .loadingTmdbDetail(message: message))
            return nil
        }
    }
    
    private func loadOmdbDetail(imdbId: String) async -> OmdbMovieResponse? {
        
        do {
            let response: OmdbMovieResponse = try await service.getOmdbMovieDetail(id: imdbId)
            return response
            
        } catch {
            let message = RequestError.getMessage(error: error)
            throwError(alertType: .loadingOmdbDetail(message: message))
            return nil
        }
    }
    
    // MARK: - Similar and recommended Movies
    
    private func fetchSimilarMovies() async -> [MovieCollection]? {
        
        guard similarPagination.canLoadMore else { return nil }
        
        do {
            let response: PageResultsResponse = try await service.getSimilarMovies(id: movieId, page: similarPagination.currentPage)
            
            return similarPagination.updateResults(response.results, totalPages: response.totalPages, resultContainerIsEmpty: similarMovies.isEmpty)
            
        } catch {
            let message = RequestError.getMessage(error: error)
            throwError(alertType: .loadingSimilar(message: message))
            return nil
        }
    }
    
    private func fetchRecommendedMovies() async -> [MovieCollection]? {
        
        guard recommendedPagination.canLoadMore else { return nil }
        
        do {
            let response: PageResultsResponse = try await service.getRecommendedMovies(id: movieId, page: recommendedPagination.currentPage)
            
            return recommendedPagination.updateResults(response.results, totalPages: response.totalPages, resultContainerIsEmpty: recommendedMovies.isEmpty)
            
        } catch {
            let message = RequestError.getMessage(error: error)
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
    
    private func throwError(alertType: MovieDetailAlert) {
        self.movieDetailAlertOption = alertType
        self.hasError = true
    }
    
    func resetError() {
        movieDetailAlertOption = .loadingTmdbDetail(message: "")
        hasError = false
    }
}
