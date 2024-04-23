//
//  OmdbSeriesResponse.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/25/24.
//

import Foundation

struct OmdbSeriesResponse: Hashable, Codable {
    let mpaRating: String?
    let awards: String?
    let ratings: [CriticRatingResponse]?
    
    enum CodingKeys: String, CodingKey {
        case mpaRating = "Rated"
        case awards = "Awards"
        case ratings = "Ratings"
    }
}
