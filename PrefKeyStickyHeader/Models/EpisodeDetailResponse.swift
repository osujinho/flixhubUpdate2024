//
//  EpisodeDetailResponse.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/19/24.
//

import Foundation

struct EpisodeDetailResponse: TmdbMedia {
    let airDate: String?
    let crew: [CrewResponse]?
    let episodeNumber: Int?
    let guests: [CastResponse]?
    let name: String?
    let plot: String?
    let id: Int
    let runtime: Int?
    let seasonNumber: Int?
    let still: String?
    let rating: Double?
    let images: MediaImage?
    let videos: [MediaVideo.VideoResults]?
    let watchProviders: WatchProvider.CountryProviders?
    
    var date: String? {
        airDate
    }
    
    var poster: String? { still }
    
    private enum CodingKeys: String, CodingKey {
        case still = "still_path"
        case airDate = "air_date"
        case plot = "overview"
        case seasonNumber = "season_number"
        case rating = "vote_average"
        case watchProviders = "watch/providers"
        case episodeNumber = "episode_number"
        case guests = "guest_stars"
        
        case name, videos, images, id, runtime, crew
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.still = try container.decodeIfPresent(String.self, forKey: .still)
        self.airDate = try container.decodeIfPresent(String.self, forKey: .airDate)
        self.plot = try container.decodeIfPresent(String.self, forKey: .plot)
        self.seasonNumber = try container.decodeIfPresent(Int.self, forKey: .seasonNumber)
        self.rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        self.episodeNumber = try container.decodeIfPresent(Int.self, forKey: .episodeNumber)
        self.guests = try container.decode([CastResponse].self, forKey: .guests)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        
        self.images = try container.decodeIfPresent(MediaImage.self, forKey: .images)
        self.id = try container.decode(Int.self, forKey: .id)
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        
        // Crews
        let crewResponse = try container.decode([CrewResponse].self, forKey: .crew)
        self.crew = CreditManager.organizeCredit(responses: crewResponse)
        
        // Watch Providers
        self.watchProviders = try container.decodeIfPresent(WatchProvider.self, forKey: .watchProviders)?.getCountryProviders(for: "US")
        
        // Videos
        let videoResponse = try container.decodeIfPresent(MediaVideo.self, forKey: .videos)
        self.videos = videoResponse?.results.filter { $0.site?.lowercased() == "youtube" }
    }
}
