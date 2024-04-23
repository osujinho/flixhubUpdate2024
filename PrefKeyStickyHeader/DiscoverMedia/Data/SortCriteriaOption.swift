//
//  SortCriteriaOption.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/5/24.
//

import Foundation

enum SortCriteriaOption: EnumPickable {
    case popularityDesc, popularityAsc, releaseDateAsc, releaseDateDesc, ratingAsc, ratingDesc, titleAsc, titleDesc
    
    var id: SortCriteriaOption { self }
    
    var name: String {
        switch self {
        case .popularityDesc: return "popularity.desc"
        case .popularityAsc: return "popularity.asc"
        case .releaseDateAsc: return "primary_release_date.asc"
        case .releaseDateDesc: return "primary_release_date.desc"
        case .ratingAsc: return "vote_average.asc"
        case .ratingDesc: return "vote_average.desc"
        case .titleAsc: return "title.asc"
        case .titleDesc: return "title.desc"
        }
    }
    
    var description: String {
        switch self {
        case .popularityDesc: return "Popularity Descending"
        case .popularityAsc: return "Popularity Ascending"
        case .releaseDateAsc: return "Release Date Ascending"
        case .releaseDateDesc: return "Release Date Descending"
        case .ratingAsc: return "Rating Ascending"
        case .ratingDesc: return "Rating Descending"
        case .titleAsc: return "Title Ascending"
        case .titleDesc: return "Title Descending"
        }
    }
}
