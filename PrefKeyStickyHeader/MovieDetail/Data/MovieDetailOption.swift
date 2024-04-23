//
//  MovieDetailOption.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/9/24.
//

import Foundation

enum MovieDetailOptions: EnumPickable {
    case about, credit, watchProviders, recommended, similar, media, review

    var id: MovieDetailOptions { self }

    var description: String {
        switch self {
        case .about: return "About"
        case .credit: return "Credit"
        case .watchProviders: return "Watch Providers"
        case .recommended: return "Suggestions"
        case .similar: return "Similar"
        case .media: return "Media"
        case .review: return "Reviews"
        }
    }
}
