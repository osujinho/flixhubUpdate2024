//
//  DiscoverViewModel.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/9/24.
//

import Foundation

@MainActor
class DiscoverViewModel: ObservableObject {
    
    @Published private(set) var discoveredMovies: [MovieCollection] = []
    @Published private(set) var discoveredSeries: [SeriesCollection] = []
    @Published private(set) var isLoading: Bool = false
    
    @Published var mediaOption: MediaOption? = .movie
    
    // MARK: - Error Handling
    @Published var hasError: Bool = false
    @Published private(set) var errorMessage: String = ""
    private var alertTitle: String {
        "Error Loading Discovered \(mediaOption?.description ?? "Media")"
    }
    
    let emtpySearchMesage: String = "Oops, looks like there's no data..."
    
    // MARK: - Discovery User data
    @Published var sortCriteria: SortCriteriaOption? = .popularityDesc
    
    @Published var certification: MpaRatingOption?
    
    @Published var seriesGenreAndOrOption: AndOrSelection? = .and
    @Published var seriesGenreSet: Set<SeriesGenre>? = []
    @Published var seriesGenres: AndOrDiscoveryData<SeriesGenre>?
    
    
//    @Published var movieGenreAndOrOption: AndOrSelection? = .and
//    @Published var movieGenreSet: Set<MovieGenre>? = []
    @Published var moviesGenres: AndOrDiscoveryData<MovieGenre>?
    
    @Published var ratingSelection: RangeOrSingle = .single
    @Published var lowestRating: RatingData?
    @Published var highestRating: RatingData?
    
    @Published var yearSelection: RangeOrSingle = .single
    @Published var startReleaseYear: YearData? = .year(YearData.currentYear)
    @Published var endReleaseYear: YearData? = .year(YearData.currentYear)
    
    @Published var streamingOptions: AndOrDiscoveryData<StreamingServiceOption>?
    
    private var service: DiscoveryServiceable
    
    private var discoverMoviesPagination: PaginationManager = PaginationManager()
    private var discoverSeriesPagination: PaginationManager = PaginationManager()
    
    private var movieDiscoveryData: MovieDiscoveryData {
        .init(
            certification: certification?.description,
            genres: moviesGenres,
            lowestRating: lowestRating?.id,
            highestRating: highestRating?.id,
            watchProvider: streamingOptions,
            startReleaseYear: startReleaseYear?.id,
            endReleaseYear: endReleaseYear?.id,
            sortBy: sortCriteria ?? .popularityDesc,
            page: discoverMoviesPagination.currentPage
        )
    }
    
    private var seriesDiscoveryData: SeriesDiscoveryData {
        .init(
            genres: seriesGenres,
            lowestRating: lowestRating?.id,
            highestRating: highestRating?.id,
            watchProvider: streamingOptions,
            startAirYear: startReleaseYear?.id,
            endAirYear: endReleaseYear?.id,
            sortBy: sortCriteria ?? .popularityDesc,
            page: discoverSeriesPagination.currentPage
        )
    }
    
    init(service: DiscoveryServiceable) {
        self.service = service
    }
}
