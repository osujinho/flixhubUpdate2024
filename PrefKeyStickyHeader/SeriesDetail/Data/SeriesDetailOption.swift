//
//  SeriesDetailOption.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/14/24.
//

import Foundation

enum SeriesDetailOption: EnumPickable {
    case about, seasons, credit, watchProviders, recommended, similar, media, review

    var id: SeriesDetailOption { self }

    var description: String {
        switch self {
        case .about: return "About"
        case .seasons: return "Seasons"
        case .credit: return "Credit"
        case .watchProviders: return "Watch Providers"
        case .recommended: return "Suggestions"
        case .similar: return "Similar"
        case .media: return "Media"
        case .review: return "Reviews"
        }
    }
}
