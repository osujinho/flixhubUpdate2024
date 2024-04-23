//
//  PageResultsResponse.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/4/24.
//

import Foundation

struct PageResultsResponse<Results: MediaCollection>: Codable {
    let page: Int
    let results: [Results]?
    let totalPages: Int?
    let totalResults: Int?
    
    private enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case page, results
    }
}

struct MovieCollection: MediaCollection {
    let id: Int
    let title: String?
    let poster: String?
    let releaseDate: String?
    let genreIds: [Int]?
    let rating: Double?
    
    private enum CodingKeys: String, CodingKey {
        case genreIds = "genre_ids"
        case poster = "poster_path"
        case releaseDate = "release_date"
        case rating = "vote_average"
        case id, title
    }
    
    var name: String? { title }
    var date: String? { releaseDate }
    var genres: String? {
        GenreManager.firstThree(genreIds: genreIds, isMovie: true)
    }
}

struct SeriesCollection: MediaCollection {
    let id: Int
    let name: String?
    let poster: String?
    let firstAirDate: String?
    let genreIds: [Int]?
    let rating: Double?
    
    private enum CodingKeys: String, CodingKey {
        case genreIds = "genre_ids"
        case poster = "poster_path"
        case firstAirDate = "first_air_date"
        case rating = "vote_average"
        case id, name
    }
    
    var date: String? { firstAirDate }
    var genres: String? {
        GenreManager.firstThree(genreIds: genreIds, isMovie: false)
    }
}

struct PersonCollection: MediaCollection {
    let id: Int
    let name: String?
    let gender: Int?
    let profile: String?
    let knownForDepartment: String?
    let appearsIn: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case knownForDepartment = "known_for_department"
        case profile = "profile_path"
        case appearsIn = "known_for"
        case id, name, gender
    }
    
    var poster: String? { profile }
    var date: String? { nil }
    var rating: Double? { nil }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.knownForDepartment = try container.decodeIfPresent(String.self, forKey: .knownForDepartment)
        self.profile = try container.decodeIfPresent(String.self, forKey: .profile)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.gender = try container.decodeIfPresent(Int.self, forKey: .gender)
        
        // Decode known for
        let knownForResponse = try container.decodeIfPresent([KnownFor].self, forKey: .appearsIn)
        self.appearsIn = Array(knownForResponse?.compactMap { $0.title ?? $0.name }.prefix(2) ?? [])
    }
    
    init(id: Int, name: String?, gender: Int?, profile: String?, knownForDepartment: String?, appearsIn: [String]?) {
        self.id = id
        self.name = name
        self.gender = gender
        self.profile = profile
        self.knownForDepartment = knownForDepartment
        self.appearsIn = appearsIn
    }
    
    private struct KnownFor: Codable {
        let title: String?
        let name: String?
    }
}
