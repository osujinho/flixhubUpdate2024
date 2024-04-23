//
//  TmdbMovieResponse.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/9/24.
//

import Foundation

// For movie detail once clicked on
struct TmdbMovieResponse: TmdbMedia {
    let backdrop: String?
    let collection: BelongsToCollection?
    let budget: Int?
    let genres: [GenreResponse]?
    let id: Int
    let imdbId: String?
    let originalLanguage: String?
    let originalTitle: String?
    let plot: String?
    let poster: String?
    let companies: [String]?
    let countries: [String]?
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let spokenLanguages: [String]?
    let status: String?
    let tagline: String?
    let title: String?
    let rating: Double?
    let mpaRating: String?
    let watchProviders: WatchProvider.CountryProviders?
    let credits: CreditResponse?
    let videos: [MediaVideo.VideoResults]?
    let images: MediaImage?
    let reviews: [CommentResponse]?
    
    var name: String? {
        title
    }
    
    var date: String? {
        releaseDate
    }
    
    private enum CodingKeys: String, CodingKey {
        case backdrop = "backdrop_path"
        case poster = "poster_path"
        case releaseDate = "release_date"
        case collection = "belongs_to_collection"
        case plot = "overview"
        case imdbId = "imdb_id"
        case rating = "vote_average"
        case originalTitle = "original_title"
        case countries = "production_countries"
        case companies = "production_companies"
        case originalLanguage = "original_language"
        case spokenLanguages = "spoken_languages"
        case watchProviders = "watch/providers"
        case mpaRating = "release_dates"
        case genres, title, runtime, credits, videos, images, status, budget, revenue, id, tagline, reviews
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.backdrop = try container.decodeIfPresent(String.self, forKey: .backdrop)
        self.collection = try container.decodeIfPresent(BelongsToCollection.self, forKey: .collection)
        self.poster = try container.decodeIfPresent(String.self, forKey: .poster)
        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)?.removeExtraSpaces
        self.plot = try container.decodeIfPresent(String.self, forKey: .plot)?.removeExtraSpaces
        self.rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)?.removeExtraSpaces
        self.title = try container.decode(String.self, forKey: .title).removeExtraSpaces
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        self.images = try container.decode(MediaImage.self, forKey: .images)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)?.removeExtraSpaces
        self.budget = try container.decodeIfPresent(Int.self, forKey: .budget)
        self.revenue = try container.decodeIfPresent(Int.self, forKey: .revenue)
        self.id = try container.decode(Int.self, forKey: .id)
        self.imdbId = try container.decodeIfPresent(String.self, forKey: .imdbId)
        self.tagline = try container.decode(String.self, forKey: .tagline).removeExtraSpaces
        
        // decode genre
        self.genres = try container.decode([GenreResponse].self, forKey: .genres)
        
        // Decode Production companies and country
        let companiesResponse = try container.decode([Name].self, forKey: .companies)
        self.companies = companiesResponse.compactMap { $0.name?.removeExtraSpaces }
        
        let countriesResponse = try container.decode([Name].self, forKey: .countries)
        self.countries = countriesResponse.compactMap { $0.name?.removeExtraSpaces }
        
        let languagesResponse = try container.decode([SpokenLanguage].self, forKey: .spokenLanguages)
        self.spokenLanguages = languagesResponse.compactMap { $0.name?.removeExtraSpaces }
        
        // MPA Rating decoding logic
        let mpaReleaseDates = try container.decode(ReleaseDates.self, forKey: .mpaRating)
        self.mpaRating = getMpaRating(releaseDates: mpaReleaseDates)
        
        // Custom decoding logic for watchProvider
        self.watchProviders = try? container.decodeIfPresent(WatchProvider.self, forKey: .watchProviders)?.getCountryProviders(for: "US")
        
        func getMpaRating(releaseDates: ReleaseDates) -> String? {
            let usaReleaseDate = releaseDates.results.first(where: { $0.iso?.lowercased() == "us" })
            let certification = usaReleaseDate?.releaseDates?
             .compactMap({ $0.certification }) // Filter out nil certifications
             .first(where: { !$0.isEmpty })  // Filter out empty certifications
             return certification?.removeExtraSpaces
        }
        
        // Decode Original Language
        let originalLanguageResponse = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        self.originalLanguage = GlobalMethods.formatLanguage(code: originalLanguageResponse)
        
        // Filter Videos
        let videoResponse = try container.decode(MediaVideo.self, forKey: .videos)
        self.videos = videoResponse.results.filter { $0.site?.lowercased() == "youtube" }
        
        // Decode Credit
        let creditResponse = try container.decodeIfPresent(CreditResponse.self, forKey: .credits)
        let organizedCasts = CreditManager.organizeCredit(responses: creditResponse?.cast)
        let organizedCrews = CreditManager.organizeCredit(responses: creditResponse?.crew)
        self.credits = CreditResponse(cast: organizedCasts, crew: organizedCrews)
        
        // Decode reviews
        let reviewResponse = try container.decodeIfPresent(PageResultsResponse<CommentResponse>.self, forKey: .reviews)
        self.reviews = reviewResponse?.results
    }
    
    struct ReleaseDates: Hashable, Codable {
        let results: [Results]
        
        struct Results: Hashable, Codable {
            let iso: String?
            let releaseDates: [Release]?
            
            enum CodingKeys: String, CodingKey {
                case releaseDates = "release_dates"
                case iso = "iso_3166_1"
            }
            
            struct Release: Hashable, Codable {
                let certification: String?
            }
        }
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
    
    struct BelongsToCollection: Hashable, Codable {
        let id: Int
        let name: String?
        let poster: String?
        let backdrop: String?
        
        private enum CodingKeys: String, CodingKey {
            case poster = "poster_path"
            case backdrop = "backdrop_path"
            case id, name
        }
    }
}
