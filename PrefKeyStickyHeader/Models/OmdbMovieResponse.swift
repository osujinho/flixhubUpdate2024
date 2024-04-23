//
//  OmdbMovieResponse.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/10/24.
//

import Foundation

struct OmdbMovieResponse: Hashable, Codable {
    let mpaRating: String?
    let awards: String?
    let boxOffice: String?
    let dvd: String?
    let ratings: [CriticRatingResponse]?
    
    enum CodingKeys: String, CodingKey {
        case mpaRating = "Rated"
        case awards = "Awards"
        case boxOffice = "BoxOffice"
        case dvd = "DVD"
        case ratings = "Ratings"
    }
}
