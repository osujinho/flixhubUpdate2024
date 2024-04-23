//
//  GlobalModel.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/21/24.
//

import Foundation

typealias WatchProviderData = WatchProvider.CountryProviders
typealias VideoDetail = MediaVideo.VideoResults

struct WatchProvider: Hashable, Codable {
    let results: [String: CountryProviders]?
    
    func getCountryProviders(for country: String) -> CountryProviders? {
        return results?[country]
    }
    
    struct CountryProviders: Hashable, Codable {
        let link: String?
        let buy: [Provider]?
        let ads: [Provider]?
        let free: [Provider]?
        let rent: [Provider]?
        let flatrate: [Provider]?
        
        struct Provider: Hashable, Codable {
            let logoPath: String?
            let providerID: Int?
            let providerName: String?
            let displayPriority: Int?
            
            enum CodingKeys: String, CodingKey {
                case logoPath = "logo_path"
                case providerID = "provider_id"
                case providerName = "provider_name"
                case displayPriority = "display_priority"
            }
        }
    }
}

struct MediaImage: Hashable, Codable {
    let backdrops: [String]?
    let posters: [String]?
    let stills: [String]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let backdropResponse = try container.decodeIfPresent([MediaImage.ImageDetail].self, forKey: .backdrops)
        self.backdrops = removeDuplicates(from: backdropResponse)?.compactMap { $0.path }
        
        let posterResponse = try container.decodeIfPresent([MediaImage.ImageDetail].self, forKey: .posters)
        self.posters = removeDuplicates(from: posterResponse)?.compactMap { $0.path }
        
        let stillsresponse = try container.decodeIfPresent([MediaImage.ImageDetail].self, forKey: .stills)
        self.stills = removeDuplicates(from: stillsresponse)?.compactMap { $0.path }
        
        func removeDuplicates(from images: [ImageDetail]?) -> [ImageDetail]? {
            
            guard let images = images, !images.isEmpty else { return nil }
            
            var uniqueDetails = [ImageDetail]()
            var uniquePaths = Set<String>()
            
            for image in images {
                if let path = image.path, !uniquePaths.contains(path) {
                    uniqueDetails.append(image)
                    uniquePaths.insert(path)
                }
            }
            
            return uniqueDetails
        }
    }
    
    init(backdrops: [String]?, posters: [String]?, stills: [String]?) {
        self.backdrops = backdrops
        self.posters = posters
        self.stills = stills
    }
    
    struct ImageDetail: Hashable, Codable {
        let rating: Double?
        let path: String?
        
        enum CodingKeys: String, CodingKey {
            case rating = "vote_average"
            case path = "file_path"
        }
    }
}

struct MediaVideo: Hashable, Codable {
    let results: [VideoResults]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawResults = try container.decode([MediaVideo.VideoResults].self, forKey: .results)
        let uniqueResults = rawResults.reduce(into: [VideoResults]()) { (unique, result) in
            if !unique.contains(where: { $0.site == result.site && $0.key == result.key }) {
                unique.append(result)
            }
        }
        self.results = uniqueResults
    }
    
    struct VideoResults: Hashable, Codable {
        let key: String
        let site: String?
        let type: String?
        let name: String?
    }
}

struct GenreResponse: Hashable, Codable {
    let id: Int?
    let name: String?
}

struct CriticRatingResponse: Hashable, Codable {
    let source: String?
    let value: String?
    
    private enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}

struct CommentResponse: MediaCollection {
    let commentId: String
    let author: String?
    let authorDetail: AuthorDetail?
    let content: String?
    let timestamp: String?
    let updatedTimestamp: String?
    let url: String?
    
    var name: String? { author ?? authorDetail?.name }
    var poster: String? { authorDetail?.avatar }
    var date: String? { timestamp }
    var rating: Double? { authorDetail?.rating }
    var id: Int {
        commentId.hashValue
    }
    
    private enum CodingKeys: String, CodingKey {
        case authorDetail = "author_details"
        case timestamp = "created_at"
        case updatedTimestamp = "updated_at"
        case commentId = "id"
        case author, content, url
    }
    
    struct AuthorDetail: Hashable, Codable {
        let name: String?
        let username: String?
        let avatar: String?
        let rating: Double?
        
        private enum CodingKeys: String, CodingKey {
            case avatar = "avatar_path"
            case name, username, rating
        }
    }
}

let mockProvider: WatchProviderData = .init(
    link: "https://www.themoviedb.org/movie/106646-the-wolf-of-wall-street/watch?locale=US",
    buy: [
        .init(logoPath: "/9ghgSC0MA082EL6HLCW3GalykFD.jpg", providerID: 2, providerName: "Apple TV", displayPriority: 4),
        .init(logoPath: "/seGSXajazLMCKGB5hnRCidtjay1.jpg", providerID: 10, providerName: "Amazon Video", displayPriority: 15),
        .init(logoPath: "/vg3nIjHVhLXnMKjQkNhQaSlsPub.jpg", providerID: 358, providerName: "DIRECTV", displayPriority: 57),
        .init(logoPath: "/1g3ULbVMEW8OVKOJymLvfboCrMv.jpg", providerID: 352, providerName: "AMC on Demand", displayPriority: 127)
    ],
    ads: [
        .init(logoPath: "/o4JMLTkDfjei1XrsVk1vSjXfdBk.jpg", providerID: 73, providerName: "Tubi TV", displayPriority: 50)
    ], 
    free: [],
    rent: [
        .init(logoPath: "/9ghgSC0MA082EL6HLCW3GalykFD.jpg", providerID: 2, providerName: "Apple Tv", displayPriority: 4),
        .init(logoPath: "/seGSXajazLMCKGB5hnRCidtjay1.jpg", providerID: 10, providerName: "Amazon Video", displayPriority: 15),
        .init(logoPath: "/8z7rC8uIDaTM91X0ZfkRf04ydj2.jpg", providerID: 3, providerName: "Google Play Movies", displayPriority: 16),
        .init(logoPath: "/pTnn5JwWr4p3pG8H6VrpiQo7Vs0.jpg", providerID: 192, providerName: "YouTube", displayPriority: 17),
        .init(logoPath: "/nVzxU8EPk0aXqQkBZniVA2kat1I.jpg", providerID: 7, providerName: "Vudu", displayPriority: 42),
        .init(logoPath: "/5vfrJQgNe9UnHVgVNAwZTy0Jo9o.jpg", providerID: 68, providerName: "Microsoft Store", displayPriority: 53)
    ],
    flatrate: [
        .init(logoPath: "/rugttVJKzDAwVbM99gAV6i3g59Q.jpg", providerID: 257, providerName: "fuboTV", displayPriority: 7),
        .init(logoPath: "/h5DcR0J2EESLitnhR8xLG1QymTE.jpg", providerID: 531, providerName: "Paramount Plus", displayPriority: 18),
        .init(logoPath: "/tJqmTmQ8jp9WfyaZfApHK8lSywA.jpg", providerID: 1853, providerName: "Paramount Plus Apple TV Channel ", displayPriority: 20),
        .init(logoPath: "/ywIoxSjoYJGUIbR6BfxUiCHdPi3.jpg", providerID: 633, providerName: "Paramount+ Roku Premium Channel", displayPriority: 31),
        .init(logoPath: "/kOI9M2PeWKFbfQ7m9VvTU0OdIe1.jpg", providerID: 37, providerName: "v", displayPriority: 46),
        .init(logoPath: "/cm1tVzivRWvZjcRSe5dwNqtw26E.jpg", providerID: 675, providerName: "Showtime Apple TV Channel", displayPriority: 278)
    ]
)
