//
//  PersonServices.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/28/24.
//

import Foundation

protocol PersonServiceable {
    func getPersonDetail(id: Int) async throws -> PersonResponse
}

struct PersonService: HTTPClient, PersonServiceable {
    func getPersonDetail(id: Int) async throws -> PersonResponse {
        return try await fetchRequest(endpoint: TmdbEndpoint.personDetail(id: id), responseModel: PersonResponse.self)
    }
}
