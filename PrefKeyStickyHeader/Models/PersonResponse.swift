//
//  PersonResponse.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/28/24.
//

import Foundation

struct PersonResponse: TmdbMedia {
    
    let id: Int
    let biography: String?
    let birthday: String?
    let deathday: String?
    let gender: Int?
    let imdbId: String?
    let knownFor: String?
    let name: String?
    let birthPlace: String?
    let poster: String?
    let taggedImages: MediaImage?
    let credit: PersonCreditData
    let images: [String?]
    
    var date: String? {
        birthday
    }
    var plot: String? { biography }
    
    var rating: Double? { nil }
    
    var knownCredits: Int? {
        if let knownFor = knownFor {
            if knownFor.lowercased() == "acting" {
                return (credit.movieCasts?.count ?? 0) + (credit.tvCasts?.count ?? 0)
            } else {
                return (credit.movieCrews?.count ?? 0) + (credit.tvCrews?.count ?? 0)
            }
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case imdbId = "imdb_id"
        case knownFor = "known_for_department"
        case birthPlace = "place_of_birth"
        case poster = "profile_path"
        case taggedImages = "tagged_images"
        case credit = "combined_credits"
        
        case id, biography, birthday, deathday, name, images, gender
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imdbId = try container.decodeIfPresent(String.self, forKey: .imdbId)
        self.knownFor = try container.decodeIfPresent(String.self, forKey: .knownFor)?.removeExtraSpaces
        self.birthPlace = try container.decodeIfPresent(String.self, forKey: .birthPlace)?.removeExtraSpaces
        self.poster = try container.decodeIfPresent(String.self, forKey: .poster)
        self.id = try container.decode(Int.self, forKey: .id)
        self.gender = try container.decode(Int.self, forKey: .gender)
        self.biography = try container.decodeIfPresent(String.self, forKey: .biography)?.removeExtraSpaces
        self.birthday = try container.decodeIfPresent(String.self, forKey: .birthday)?.removeExtraSpaces
        self.deathday = try container.decodeIfPresent(String.self, forKey: .deathday)?.removeExtraSpaces
        self.name = try container.decodeIfPresent(String.self, forKey: .name)?.removeExtraSpaces
        
        // Parse Tagged Images
        let taggedImageResponse = try container.decodeIfPresent(TaggedImage.self, forKey: .taggedImages)
        self.taggedImages = getTaggedResult(results: taggedImageResponse?.results)
        
        func getTaggedResult(results: [TaggedImage.TaggedImageResult]?) -> MediaImage? {
            
            guard let results = results, !results.isEmpty else { return nil }
            
            let backdrops: String = "backdrops"
            let posters: String = "posters"
            
            var mediaDictionary: [String: [String?]] = [backdrops: [], posters: []]
            var uniquePaths: Set<String> = []

            // Populate the dictionary
            for taggedImageResult in results {
                
                if let aspectRatio = taggedImageResult.aspectRatio, let path = taggedImageResult.path, !uniquePaths.contains(path) {
                    let mediaType = aspectRatio < 1 ? posters : backdrops
                    mediaDictionary[mediaType]?.append(path)
                    uniquePaths.insert(path)
                }
                
                if let poster = taggedImageResult.media?.poster, !uniquePaths.contains(poster) {
                    mediaDictionary[posters]?.append(poster)
                    uniquePaths.insert(poster)
                }
                
                if let backdrop = taggedImageResult.media?.backdrop, !uniquePaths.contains(backdrop) {
                    mediaDictionary[backdrops]?.append(backdrop)
                    uniquePaths.insert(backdrop)
                }
                
                if let still = taggedImageResult.media?.still, !uniquePaths.contains(still) {
                    mediaDictionary[backdrops]?.append(still)
                    uniquePaths.insert(still)
                }
            }
            
            if let uniqueBackdrops = mediaDictionary[backdrops], let uniquePosters = mediaDictionary[posters] {
                return MediaImage(
                    backdrops: uniqueBackdrops.compactMap { $0 },
                    posters: uniquePosters.compactMap { $0 }, 
                    stills: nil
                )
            }
            return nil
        }
        
        // Parse Images
        let imagesResponse = try container.decode(ResponseImages.self, forKey: .images)
        self.images = imagesResponse.profiles?.map { $0.path } ?? []
        
        // Parse Credit
        let creditResponse = try container.decodeIfPresent(PersonResponse.Credit.self, forKey: .credit)
        self.credit = PersonCreditData(credit: creditResponse)
    }
    
    struct TaggedImage: Hashable, Codable {
        let page: Int?
        let results: [TaggedImageResult]?
        let totalPages: Int?
        
        enum CodingKeys: String, CodingKey {
            case totalPages = "total_pages"
            case page, results
        }
        
        struct TaggedImageResult: Hashable, Codable {
            let aspectRatio: Double?
            let path: String?
            let media: ResultMedia?
            
            enum CodingKeys: String, CodingKey {
                case path = "file_path"
                case aspectRatio = "aspect_ratio"
                case media
            }
            
            struct ResultMedia: Hashable, Codable {
                let backdrop: String?
                let poster: String?
                let still: String?
                
                enum CodingKeys: String, CodingKey {
                    case backdrop = "backdrop_path"
                    case poster = "poster_path"
                    case still = "still_path"
                }
            }
        }
    }
    
    struct Credit: Hashable, Codable {
        let cast: [Cast]
        let crew: [Crew]
        
       enum Cast: Hashable, Codable {
            case movie(PersonCastMovie)
            case tv(PersonCastSeries)
            
            enum CodingKeys: String, CodingKey {
                case type = "media_type"
            }
            
            enum Types: String, Codable {
                case movie, tv
            }
            
            var castData: any MediaCollection {
                switch self {
                case .movie(let data): return data
                case .tv(let data): return data
                }
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decode(Types.self, forKey: .type)
                
                switch type {
                case .movie:
                    let movieData = try PersonCastMovie(from: decoder)
                    self = .movie(movieData)
                case .tv:
                    let tvData = try PersonCastSeries(from: decoder)
                    self = .tv(tvData)
                }
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                switch self {
                case .movie(let movieData):
                    try container.encode(Types.movie, forKey: .type)
                    try movieData.encode(to: encoder)
                case .tv(let tvData):
                    try container.encode(Types.tv, forKey: .type)
                    try tvData.encode(to: encoder)
                }
            }
        }
        
        enum Crew: Hashable, Codable {
            case movie(PersonCrewMovie)
            case tv(PersonCrewSeries)
            
            enum CodingKeys: String, CodingKey {
                case type = "media_type"
            }
            
            enum Types: String, Codable {
                case movie, tv
            }
            
            var castData: any MediaCollection {
                switch self {
                case .movie(let data): return data
                case .tv(let data): return data
                }
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decode(Types.self, forKey: .type)
                
                switch type {
                case .movie:
                    let movieData = try PersonCrewMovie(from: decoder)
                    self = .movie(movieData)
                case .tv:
                    let tvData = try PersonCrewSeries(from: decoder)
                    self = .tv(tvData)
                }
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                switch self {
                case .movie(let movieData):
                    try container.encode(Types.movie, forKey: .type)
                    try movieData.encode(to: encoder)
                case .tv(let tvData):
                    try container.encode(Types.tv, forKey: .type)
                    try tvData.encode(to: encoder)
                }
            }
        }
    }
    
    struct ResponseImages: Hashable, Codable {
        let profiles: [MediaImage.ImageDetail]?
    }
}
