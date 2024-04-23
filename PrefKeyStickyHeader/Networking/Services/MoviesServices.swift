//
//  MoviesServices.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/9/24.
//

import Foundation

protocol MovieServiceable {
    func getTmdbMovieDetail(id: Int) async throws -> TmdbMovieResponse
    func getOmdbMovieDetail(id: String) async throws -> OmdbMovieResponse
    func getSimilarMovies(id: Int, page: Int) async throws -> PageResultsResponse<MovieCollection>
    func getRecommendedMovies(id: Int, page: Int) async throws -> PageResultsResponse<MovieCollection>
    func getBelongsToCollection(collectionId: Int) async throws -> MovieCollectionResponse
    //func getRapidMovieService(tmdbId: Int) async throws -> RapidMovieResponse
}

struct MovieService: HTTPClient, MovieServiceable {
    
    func getTmdbMovieDetail(id: Int) async throws -> TmdbMovieResponse {
        return try await fetchRequest(endpoint: TmdbEndpoint.movieDetail(id: id), responseModel: TmdbMovieResponse.self)
    }
    
    func getOmdbMovieDetail(id: String) async throws -> OmdbMovieResponse {
        return try await fetchRequest(endpoint: OmdbEndpoint.movieDetail(id: id), responseModel: OmdbMovieResponse.self)
    }
    
    func getSimilarMovies(id: Int, page: Int) async throws -> PageResultsResponse<MovieCollection> {
        return try await fetchRequest(endpoint: TmdbEndpoint.similarMovies(id: id, page: page), responseModel: PageResultsResponse<MovieCollection>.self)
    }
    
    func getRecommendedMovies(id: Int, page: Int) async throws -> PageResultsResponse<MovieCollection> {
        return try await fetchRequest(endpoint: TmdbEndpoint.recommendedMovies(id: id, page: page), responseModel: PageResultsResponse<MovieCollection>.self)
    }
    
    func getBelongsToCollection(collectionId: Int) async throws -> MovieCollectionResponse {
        return try await fetchRequest(endpoint: TmdbEndpoint.belongsToCollection(collectionId: collectionId), responseModel: MovieCollectionResponse.self)
    }
    
//    func getRapidMovieService(tmdbId: Int) async throws -> RapidMovieResponse {
//        return try await fetchRequest(endpoint: RapidEndpoint.movie(tmdbId: tmdbId), responseModel: RapidMovieResponse.self)
//    }
}
