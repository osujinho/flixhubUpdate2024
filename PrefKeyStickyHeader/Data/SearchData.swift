//
//  SearchData.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/11/24.
//

import Foundation

enum SearchMediaType: EnumPickable {
    case movie, series, person
    
    var id: SearchMediaType { self }

    var description: String {
        switch self {
        case .movie: return "Movie"
        case .series: return "Series"
        case .person: return "Person"
        }
    }
}
