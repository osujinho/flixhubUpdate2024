//
//  SearchServices.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/5/24.
//

import Foundation

protocol SearchServiceable {
    func searchMovie(query: String, page: Int) async throws -> PageResultsResponse<MovieCollection>
    func searchSeries(query: String, page: Int) async throws -> PageResultsResponse<SeriesCollection>
    func searchPerson(query: String, page: Int) async throws -> PageResultsResponse<PersonCollection>
}

struct SearchService: HTTPClient, SearchServiceable {
    func searchMovie(query: String, page: Int) async throws -> PageResultsResponse<MovieCollection> {
        return try await fetchRequest(endpoint: TmdbEndpoint.searchMovie(query: query, page: page), responseModel: PageResultsResponse<MovieCollection>.self)
    }
    
    func searchSeries(query: String, page: Int) async throws -> PageResultsResponse<SeriesCollection> {
        return try await fetchRequest(endpoint: TmdbEndpoint.searchSeries(query: query, page: page), responseModel: PageResultsResponse<SeriesCollection>.self)
    }
    
    func searchPerson(query: String, page: Int) async throws -> PageResultsResponse<PersonCollection> {
        return try await fetchRequest(endpoint: TmdbEndpoint.searchPerson(query: query, page: page), responseModel: PageResultsResponse<PersonCollection>.self)
    }
}
