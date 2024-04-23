//
//  TmdbSeriesResponse.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/21/24.
//

import Foundation

typealias SeriesNetworkResponse = TmdbSeriesResponse.Network

// For series detail once clicked on
struct TmdbSeriesResponse: TmdbMedia {
    let id: Int
    let backdrop: String?
    let creators: [CrewResponse]?
    let runtime: [Int]?
    let firstAirDate: String?
    let genres: [GenreResponse]?
    let inProduction: Bool?
    let languages: [String]
    let lastAirDate: String?
    let lastEpisode: EpisodeCollection?
    let name: String?
    let nextEpisode: EpisodeCollection?
    let networks: [Network]?
    let totalEpisodes: Int?
    let totalSeasons: Int?
    let originCountry: [String]?
    let originalLanguage: String?
    let originalName: String?
    let plot: String?
    let poster: String?
    let companies: [String]?
    let countries: [String]?
    let seasons: [SeasonCollection]
    let spokenLanguages: [String]?
    let status: String?
    let type: String?
    let tagline: String?
    let rating: Double?
    let mpaRating: String?
    let credits: CreditResponse?
    let imdbId: String?
    let images: MediaImage?
    let watchProviders: WatchProvider.CountryProviders?
    let videos: [MediaVideo.VideoResults]?
    let reviews: [CommentResponse]?
    
    var date: String? {
        firstAirDate
    }
    
    private enum CodingKeys: String, CodingKey {
        case backdrop = "backdrop_path"
        case creators = "created_by"
        case runtime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case inProduction = "in_production"
        case lastAirDate = "last_air_date"
        case lastEpisode = "last_episode_to_air"
        case nextEpisode = "next_episode_to_air"
        case totalEpisodes = "number_of_episodes"
        case totalSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalName = "original_name"
        case plot = "overview"
        case poster = "poster_path"
        case countries = "production_countries"
        case companies = "production_companies"
        case spokenLanguages = "spoken_languages"
        case rating = "vote_average"
        case mpaRating = "content_ratings"
        case imdbId = "external_ids"
        case originalLanguage = "original_language"
        case watchProviders = "watch/providers"
        case genres, name, credits, videos, images, status, id, languages, networks, seasons, type, tagline, reviews
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.backdrop = try container.decodeIfPresent(String.self, forKey: .backdrop)
        self.runtime = try container.decodeIfPresent([Int].self, forKey: .runtime)
        self.firstAirDate = try container.decodeIfPresent(String.self, forKey: .firstAirDate)
        self.inProduction = try container.decodeIfPresent(Bool.self, forKey: .inProduction)
        self.lastAirDate = try container.decodeIfPresent(String.self, forKey: .lastAirDate)
        self.lastEpisode = try container.decodeIfPresent(EpisodeCollection.self, forKey: .lastEpisode)
        self.nextEpisode = try container.decodeIfPresent(EpisodeCollection.self, forKey: .nextEpisode)
        self.totalEpisodes = try container.decodeIfPresent(Int.self, forKey: .totalEpisodes)
        self.totalSeasons = try container.decodeIfPresent(Int.self, forKey: .totalSeasons)
        self.originalName = try container.decodeIfPresent(String.self, forKey: .originalName)
        self.plot = try container.decodeIfPresent(String.self, forKey: .plot)
        self.poster = try container.decodeIfPresent(String.self, forKey: .poster)
        self.rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.images = try container.decodeIfPresent(MediaImage.self, forKey: .images)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.id = try container.decode(Int.self, forKey: .id)
        self.networks = try container.decodeIfPresent([TmdbSeriesResponse.Network].self, forKey: .networks)
        self.seasons = try container.decode([SeasonCollection].self, forKey: .seasons)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
        
        // Decode Creator
        let creatorResponse = try container.decodeIfPresent([TmdbSeriesResponse.Creator].self, forKey: .creators)
        self.creators = getCrewFromCreators(creators: creatorResponse)
        
        func getCrewFromCreators(creators: [Creator]?) -> [CrewResponse]? {
            if let creators = creators, !creators.isEmpty {
                let creatorCrews: [CrewResponse] = creators.map { .init(id: $0.id, name: $0.name, picture: $0.profilePath, job: "Creator") }
                return creatorCrews
            }
            return nil
        }
        
        // Decode Genres
        self.genres = try container.decodeIfPresent([GenreResponse].self, forKey: .genres)
        
        // Decode language
        let languagesResponse = try container.decodeIfPresent([String].self, forKey: .languages)
        self.languages = getLanguages(languages: languagesResponse)
        
        func getLanguages(languages: [String]?) -> [String] {
            if let languages = languages, !languages.isEmpty {
                return languages.compactMap { GlobalMethods.formatLanguage(code: $0) }
            }
            return []
        }
        
        // decode origin country
        let originCountryResponse = try container.decodeIfPresent([String].self, forKey: .originCountry)
        self.originCountry = getOriginCountries(countries: originCountryResponse)
        
        func getOriginCountries(countries: [String]?) -> [String] {
            if let countries = countries, !countries.isEmpty {
                return countries.compactMap { GlobalMethods.formatCountry(countryCode: $0) }
            }
            return []
        }
        
        // Decode original Language
        let originalLanguageResponse = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        self.originalLanguage = GlobalMethods.formatLanguage(code: originalLanguageResponse)
        
        // decode Spoken languages
        let spokenLanguagesResponse = try container.decodeIfPresent([SpokenLanguage].self, forKey: .spokenLanguages)
        self.spokenLanguages = spokenLanguagesResponse?.compactMap { $0.name }
        
        // Decode Production companies and country
        let companiesResponse = try container.decode([Name].self, forKey: .companies)
        self.companies = companiesResponse.compactMap { $0.name }
        
        let countriesResponse = try container.decode([Name].self, forKey: .countries)
        self.countries = countriesResponse.compactMap { $0.name }
        
        // Decode MPA Rating
        let mpaRatingResponse = try container.decodeIfPresent(ContentRatings.self, forKey: .mpaRating)
        self.mpaRating = getMpaRating(contentRating: mpaRatingResponse)
        
        func getMpaRating(contentRating: ContentRatings?) -> String? {
            let usaRating = contentRating?.results.first(where: { $0.iso?.lowercased() == "us" })
            return usaRating?.rating
        }
        
        // Decode Credit
        let creditResponse = try container.decodeIfPresent(CreditResponse.self, forKey: .credits)
        let organizedCasts = CreditManager.organizeCredit(responses: creditResponse?.cast)
        let organizedCrews = CreditManager.organizeCredit(responses: creditResponse?.crew, creators: creators)
        self.credits = CreditResponse(cast: organizedCasts, crew: organizedCrews)
        
        // Decode imdbId
        let imdbIdResponse = try container.decodeIfPresent(ExternalIds.self, forKey: .imdbId)
        self.imdbId = imdbIdResponse?.imdb
        
        // Decode Watch providers
        self.watchProviders = try container.decodeIfPresent(WatchProvider.self, forKey: .watchProviders)?.getCountryProviders(for: "US")
        
        // Decode Videos
        let videoResponse = try container.decodeIfPresent(MediaVideo.self, forKey: .videos)
        self.videos = videoResponse?.results.filter { $0.site?.lowercased() == "youtube" }
        
        // Decode reviews
        let reviewResponse = try container.decodeIfPresent(PageResultsResponse<CommentResponse>.self, forKey: .reviews)
        self.reviews = reviewResponse?.results
    }
    
    struct Creator: Hashable, Codable {
        let id: Int
        let name: String?
        let profilePath: String?
        
        private enum CodingKeys: String, CodingKey {
            case id, name
            case profilePath = "profile_path"
        }
    }
    
    struct Genre: Hashable, Codable {
        let id: Int?
        let name: String?
    }
    
    struct SpokenLanguage: Hashable, Codable {
        let name: String?
        let code: String?
        
        private enum CodingKeys: String, CodingKey {
            case name = "english_name"
            case code = "iso_639_1"
        }
    }
    
    struct Name: Hashable, Codable {
        let name: String?
    }
    
    struct ExternalIds: Hashable, Codable {
        let imdb: String?
        
        private enum CodingKeys: String, CodingKey {
            case imdb = "imdb_id"
        }
    }
    
    struct Network: Hashable, Codable {
        let id: Int?
        let logo: String?
        let name: String?
        
        private enum CodingKeys: String, CodingKey {
            case id, name
            case logo = "logo_path"
        }
    }
    
    struct ContentRatings: Hashable, Codable {
        let results: [Results]
        
        struct Results: Hashable, Codable {
            let iso: String?
            let rating: String?
            
            enum CodingKeys: String, CodingKey {
                case rating
                case iso = "iso_3166_1"
            }
        }
    }
}
