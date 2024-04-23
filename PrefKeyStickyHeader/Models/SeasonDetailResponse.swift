//
//  SeasonDetailResponse.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/19/24.
//

import Foundation

struct SeasonDetailResponse: TmdbMedia {
    let airDate: String?
    let episodes: [EpisodeCollection]?
    let name: String?
    let plot: String?
    let id: Int
    let poster: String?
    let seasonNumber: Int?
    let rating: Double?
    let videos: [MediaVideo.VideoResults]?
    let images: MediaImage?
    let watchProviders: WatchProvider.CountryProviders?
    
    var date: String? {
        airDate
    }
    var totalEpisodes: Int {
        if let episodes = episodes, !episodes.isEmpty {
            return episodes.count
        }
        return 0
    }
    
    private enum CodingKeys: String, CodingKey {
        case poster = "poster_path"
        case airDate = "air_date"
        case plot = "overview"
        case seasonNumber = "season_number"
        case rating = "vote_average"
        case watchProviders = "watch/providers"
        
        case name, videos, images, id, episodes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.poster = try container.decodeIfPresent(String.self, forKey: .poster)
        self.airDate = try container.decodeIfPresent(String.self, forKey: .airDate)
        self.plot = try container.decodeIfPresent(String.self, forKey: .plot)
        self.seasonNumber = try container.decodeIfPresent(Int.self, forKey: .seasonNumber)
        self.rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        
        self.images = try container.decodeIfPresent(MediaImage.self, forKey: .images)
        self.id = try container.decode(Int.self, forKey: .id)
        self.episodes = try container.decodeIfPresent([EpisodeCollection].self, forKey: .episodes)
        
        // watch Providers
        self.watchProviders = try container.decodeIfPresent(WatchProvider.self, forKey: .watchProviders)?.getCountryProviders(for: "US")
        
        // Videos
        let videoResponse = try container.decodeIfPresent(MediaVideo.self, forKey: .videos)
        self.videos = videoResponse?.results.filter { $0.site?.lowercased() == "youtube" }
    }
}
