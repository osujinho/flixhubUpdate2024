//
//  MovieCollectionServices.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/2/24.
//

import Foundation

protocol MovieCollectionServiceable {
    func getBelongsToCollection(collectionId: Int) async throws -> MovieCollectionResponse
}

struct MovieCollectionService: HTTPClient, MovieCollectionServiceable {
    
    func getBelongsToCollection(collectionId: Int) async throws -> MovieCollectionResponse {
        return try await fetchRequest(endpoint: TmdbEndpoint.belongsToCollection(collectionId: collectionId), responseModel: MovieCollectionResponse.self)
    }
}
