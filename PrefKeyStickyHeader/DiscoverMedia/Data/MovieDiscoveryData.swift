//
//  MovieDiscoveryData.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/7/24.
//

import SwiftUI

struct AndOrDiscoveryData<Value: IntIdentifiable>: AndOrSelectable {
    var value: Set<Value>
    var andOr: AndOrSelection
    
//    init(value: Set<Value>, andOr: AndOrSelection = .and) {
//        self.value = Set(value.map { $0.id })
//        self.andOr = andOr
//    }
}

//struct AndOrDiscoveryData<Value: IntIdentifiable>: AndOrSelectable {
//    var value: Binding<Set<Int>>
//    var andOr: Binding<AndOrSelection>
//    
//    init(value: Set<Value>, andOr: AndOrSelection = .and) {
//        self.value = .constant(Set(value.map { $0.id }))
//        self.andOr = .constant(andOr)
//    }
//}

struct MovieDiscoveryData {
    var certification: String?
    var genres: AndOrDiscoveryData<MovieGenre>?
    var lowestRating: Int?
    var highestRating: Int?
    var watchProvider: AndOrDiscoveryData<StreamingServiceOption>?
    var startReleaseYear: Int?
    var endReleaseYear: Int?
    var sortBy: SortCriteriaOption
    var page: Int
    
    init(certification: String? = nil, genres: AndOrDiscoveryData<MovieGenre>? = nil, lowestRating: Int? = nil, highestRating: Int? = nil, watchProvider: AndOrDiscoveryData<StreamingServiceOption>? = nil, startReleaseYear: Int? = nil, endReleaseYear: Int? = nil, sortBy: SortCriteriaOption = .popularityDesc, page: Int = 1) {
        self.certification = certification
        self.genres = genres
        self.lowestRating = lowestRating
        self.highestRating = highestRating
        self.watchProvider = watchProvider
        self.startReleaseYear = startReleaseYear
        self.endReleaseYear = endReleaseYear
        self.sortBy = sortBy
        self.page = page
    }
}

struct SeriesDiscoveryData {
    var genres: AndOrDiscoveryData<SeriesGenre>?
    var lowestRating: Int?
    var highestRating: Int?
    var watchProvider: AndOrDiscoveryData<StreamingServiceOption>?
    var startAirYear: Int?
    var endAirYear: Int?
    var sortBy: SortCriteriaOption
    var page: Int
    
    init(genres: AndOrDiscoveryData<SeriesGenre>? = nil, lowestRating: Int? = nil, highestRating: Int? = nil, watchProvider: AndOrDiscoveryData<StreamingServiceOption>? = nil, startAirYear: Int? = nil, endAirYear: Int? = nil, sortBy: SortCriteriaOption = .popularityDesc, page: Int = 1) {
        self.genres = genres
        self.lowestRating = lowestRating
        self.highestRating = highestRating
        self.watchProvider = watchProvider
        self.startAirYear = startAirYear
        self.endAirYear = endAirYear
        self.sortBy = sortBy
        self.page = page
    }
}
