//
//  SeriesServices.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/25/24.
//

import Foundation

protocol SeriesServiceable {
    func getSeriesDetail(id: Int) async throws -> TmdbSeriesResponse
    func getOmdbSeriesDetail(id: String) async throws -> OmdbSeriesResponse
    func getSimilarSeries(id: Int, page: Int) async throws -> PageResultsResponse<SeriesCollection>
    func getRecommendedSeries(id: Int, page: Int) async throws -> PageResultsResponse<SeriesCollection>
}

struct SeriesService: HTTPClient, SeriesServiceable {
    
    func getSeriesDetail(id: Int) async throws -> TmdbSeriesResponse {
        return try await fetchRequest(endpoint: TmdbEndpoint.seriesDetail(id: id), responseModel: TmdbSeriesResponse.self)
    }
    
    func getOmdbSeriesDetail(id: String) async throws -> OmdbSeriesResponse {
        return try await fetchRequest(endpoint: OmdbEndpoint.seriesDetail(id: id), responseModel: OmdbSeriesResponse.self)
    }
    
    func getSimilarSeries(id: Int, page: Int) async throws -> PageResultsResponse<SeriesCollection> {
        return try await fetchRequest(endpoint: TmdbEndpoint.similarSeries(id: id, page: page), responseModel: PageResultsResponse<SeriesCollection>.self)
    }
    
    func getRecommendedSeries(id: Int, page: Int) async throws -> PageResultsResponse<SeriesCollection> {
        return try await fetchRequest(endpoint: TmdbEndpoint.recommendedSeries(id: id, page: page), responseModel: PageResultsResponse<SeriesCollection>.self)
    }
}
