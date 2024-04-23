//
//  SeasonAndEpisodeCollectionResponse.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/14/24.
//

import Foundation

struct EpisodeCollection: SeasonAndEpisodeCollection {
    let id: Int
    let showId: Int?
    let name: String?
    let rating: Double?
    let airDate: String?
    let number: Int?
    let runtime: Int?
    let seasonNumber: Int?
    let stillImage: String?
    
    var image: String? { stillImage }
    var poster: String? { stillImage }
    var date: String? { airDate }
    
    private enum CodingKeys: String, CodingKey {
        case name, id, runtime
        case showId = "show_id"
        case rating = "vote_average"
        case stillImage = "still_path"
        case airDate = "air_date"
        case number = "episode_number"
        case seasonNumber = "season_number"
    }
}

struct SeasonCollection: SeasonAndEpisodeCollection {
    let id: Int
    let name: String?
    let airDate: String?
    let totalEpisodes: Int?
    let poster: String?
    let number: Int?
    let rating: Double?
    
    var image: String? { poster }
    var date: String? { airDate }
    
    private enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case totalEpisodes = "episode_count"
        case poster = "poster_path"
        case number = "season_number"
        case rating = "vote_average"
    }
}

extension EpisodeCollection {
    static var mockEpisode: EpisodeCollection = .init(
        id: 63912,
        showId: 1408,
        name: "Everybody Dies",
        rating: 8.4,
        airDate: "2012-05-21",
        number: 22,
        runtime: 44,
        seasonNumber: 8,
        stillImage: "/pxE5r8vsNZPZodu2oms7efYLH82.jpg"
    )
}

extension SeasonCollection {
    static var mockSeason: SeasonCollection = .init(
        id: 3674,
        name: "Season 1",
        airDate: "2004-11-16",
        totalEpisodes: 22,
        poster: "/lXBIhFheyDRA72vRQvYF1mkEF27.jpg",
        number: 1,
        rating: 7.7
    )
}
