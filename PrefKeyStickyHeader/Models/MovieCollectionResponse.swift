//
//  MovieCollectionResponse.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/2/24.
//

import Foundation

struct MovieCollectionResponse: TmdbMedia {
    let id: Int
    let name: String?
    let overview: String?
    let poster: String?
    let backdrop: String?
    let parts: [MovieCollection]?
    let images: MediaImage?
    
    var date: String? { nil }
    var rating: Double? { nil }
    var plot: String? { overview }
    
    private enum CodingKeys: String, CodingKey {
        case poster = "poster_path"
        case backdrop = "backdrop_path"
        case id, name, overview, parts, images
    }
}
