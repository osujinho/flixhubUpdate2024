//
//  SearchViewModel.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/17/24.
//

import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var searchText = "" {
        didSet {
            if searchText == "" {
                cancelAction()
            }
        }
    }
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var movies: [MovieCollection] = []
    @Published private(set) var fetchedSeries: [SeriesCollection] = []
    @Published private(set) var people: [PersonCollection] = []
    
    @Published var searchScopeOption: SearchMediaType? = .movie
    @Published var hasError: Bool = false
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var searchAlert: SearchAlert = .loadingMovies(message: "")
    
    let emtpySearchMesage: String = "Oops, looks like there's no data..."
    
    private var moviesPagination: PaginationManager = PaginationManager()
    private var seriesPagination: PaginationManager = PaginationManager()
    private var peoplePagination: PaginationManager = PaginationManager()
    
    private var service: SearchServiceable
    
    var isAllEmpty: Bool {
        movies.isEmpty && fetchedSeries.isEmpty && people.isEmpty
    }
    
    init(service: SearchServiceable) {
        self.service = service
        configureCancellables()
    }
    
    func configureCancellables() {
        $searchText
            .removeDuplicates(by: { $0 == $1 })
            .debounce(for: 1, scheduler: RunLoop.main)
            .filter({ $0.count >= 3 })
            .sink { [weak self] value in
                guard let self = self else { return }
                Task {
                    await self.searchGivenText(query: value)
                }
            }
            .store(in: &cancellables)
    }
    
    func searchGivenText(query: String) async {
        
        guard !isLoading else { return }
        cancelAction()
        self.isLoading = true
        
        async let moviesTask = searchMovie(query: query)
        async let seriesTask = searchSeries(query: query)
        async let peopleTask = searchPerson(query: query)
        
        let (moviesResult, seriesResult, peopleResult) = await (moviesTask, seriesTask, peopleTask)
        self.movies = moviesResult
        self.fetchedSeries = seriesResult
        self.people = peopleResult
        self.isLoading = false
    }
    
    func loadMoreMoviesIfNeeded(currentMovie movie: MovieCollection?) async {
        
        guard !isLoading else { return }
        
        await moviesPagination.loadMoreIfNeeded(currentItem: movie, items: movies) { [weak self] in
            
            guard let self = self else { return }
            
            self.resetError()
            self.isLoading = true
            
            let newMovies = await self.searchMovie(query: searchText)
            movies.append(contentsOf: newMovies)
            isLoading = false
        }
    }
    
    func loadMoreSeriesIfNeeded(currentSeries series: SeriesCollection?) async {
        
        guard !isLoading else { return }
        
        await seriesPagination.loadMoreIfNeeded(currentItem: series, items: fetchedSeries) { [weak self] in
            
            guard let self = self else { return }
            
            self.resetError()
            isLoading = true
            
            let newSeries = await self.searchSeries(query: searchText)
            fetchedSeries.append(contentsOf: newSeries)
            isLoading = false
        }
    }
    
    func loadMorePeopleIfNeeded(currentPerson person: PersonCollection?) async {
        
        guard !isLoading else { return }
        
        await peoplePagination.loadMoreIfNeeded(currentItem: person, items: people) { [weak self] in
            
            guard let self = self else { return }
            
            self.resetError()
            isLoading = true
            
            let newPeople = await self.searchPerson(query: searchText)
            people.append(contentsOf: newPeople)
            isLoading = false
        }
    }
    
    func cancelAction() {
        movies = []
        fetchedSeries = []
        people = []
        moviesPagination.reset()
        seriesPagination.reset()
        peoplePagination.reset()
        resetError()
    }
    
    private func searchMovie(query: String) async -> [MovieCollection] {
        
        guard moviesPagination.canLoadMore else { return [] }
        
        do {
            let searchResponse: PageResultsResponse<MovieCollection> = try await service.searchMovie(query: query, page: moviesPagination.currentPage)
            
            return moviesPagination.updateResults(searchResponse.results, totalPages: searchResponse.totalPages, resultContainerIsEmpty: movies.isEmpty)
            
        } catch {
            let message = RequestError.getMessage(error: error)
            throwError(alertType: .loadingMovies(message: message))
            return []
        }
    }
    
    private func searchSeries(query: String) async -> [SeriesCollection] {
        
        guard seriesPagination.canLoadMore else { return [] }
        
        do {
            let searchResponse: PageResultsResponse<SeriesCollection> = try await service.searchSeries(query: query, page: seriesPagination.currentPage)
            
            return seriesPagination.updateResults(searchResponse.results, totalPages: searchResponse.totalPages, resultContainerIsEmpty: fetchedSeries.isEmpty)
            
        } catch {
            let message = RequestError.getMessage(error: error)
            throwError(alertType: .loadingSeries(message: message))
            return []
        }
    }
    
    private func searchPerson(query: String) async -> [PersonCollection] {
        
        guard peoplePagination.canLoadMore else { return [] }
        
        do {
            let searchResponse: PageResultsResponse<PersonCollection> = try await service.searchPerson(query: query, page: peoplePagination.currentPage)
            
            return peoplePagination.updateResults(searchResponse.results, totalPages: searchResponse.totalPages, resultContainerIsEmpty: people.isEmpty)
            
        } catch {
            let message = RequestError.getMessage(error: error)
            throwError(alertType: .loadingPeople(message: message))
            return []
        }
    }
    
    private func throwError(alertType: SearchAlert) {
        self.searchAlert = alertType
        self.hasError = true
    }
    
    private func resetError() {
        searchAlert = .loadingMovies(message: "")
        hasError = false
    }
}
