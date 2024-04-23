//
//  DiscoveryServices.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/7/24.
//

import Foundation

protocol DiscoveryServiceable {
    func discoverMovies(movieDiscoveryData: MovieDiscoveryData) async throws -> PageResultsResponse<MovieCollection>
    func discoverSeries(seriesDiscoveryData: SeriesDiscoveryData) async throws -> PageResultsResponse<SeriesCollection>
}

struct DiscoveryService: HTTPClient, DiscoveryServiceable {
    
    func discoverMovies(movieDiscoveryData: MovieDiscoveryData) async throws -> PageResultsResponse<MovieCollection> {
        return try await fetchRequest(endpoint: TmdbEndpoint.discoverMovie(movieDiscoveryData: movieDiscoveryData), responseModel: PageResultsResponse<MovieCollection>.self)
    }
    
    func discoverSeries(seriesDiscoveryData: SeriesDiscoveryData) async throws -> PageResultsResponse<SeriesCollection> {
        return try await fetchRequest(endpoint: TmdbEndpoint.discoverSeries(seriesDiscoveryData: seriesDiscoveryData), responseModel: PageResultsResponse<SeriesCollection>.self)
    }
}
