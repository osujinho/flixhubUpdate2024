//
//  CreditResponse.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/12/24.
//

import Foundation

struct CreditResponse: Hashable, Codable {
    var cast: [CastResponse]
    var crew: [CrewResponse]
    
    private enum CodingKeys: String, CodingKey {
        case cast
        case crew
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cast = try container.decode([CastResponse].self, forKey: .cast)
        self.crew = try container.decode([CrewResponse].self, forKey: .crew)
    }
    
    init(cast: [CastResponse]?, crew: [CrewResponse]?) {
        self.cast = cast ?? []
        self.crew = crew ?? []
    }
}

struct CastResponse: MovieAndSeriesCreditCollection {
    let id: Int
    let name: String?
    let picture: String?
    let character: String?
    let order: Int?
    
    var role: String? { character }
    
    enum CodingKeys: String, CodingKey {
        case picture = "profile_path"
        case name, character, id, order
    }
}

struct CrewResponse: MovieAndSeriesCreditCollection {
    let id: Int
    let name: String?
    let picture: String?
    let job: String?
    
    var role: String? { job }
    
    enum CodingKeys: String, CodingKey {
        case picture = "profile_path"
        case name, job, id
    }
}
