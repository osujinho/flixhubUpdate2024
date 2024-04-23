//
//  SeasonAndEpisodeService.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/19/24.
//

import Foundation

protocol SeasonAndEpisodeServiceable {
    func getEpisodeDetail(seriesId: Int, seasonNumber: Int, episodeNumber: Int) async throws -> EpisodeDetailResponse
    
    func getSeasonDetail(seriesId: Int, seasonNumber: Int) async throws -> SeasonDetailResponse
}

struct SeasonAndEpisodeService: HTTPClient, SeasonAndEpisodeServiceable {
    
    func getEpisodeDetail(seriesId: Int, seasonNumber: Int, episodeNumber: Int) async throws -> EpisodeDetailResponse {
        
        return try await fetchRequest(
            endpoint: TmdbEndpoint.episodeDetail(seriesId: seriesId, seasonNumber: seasonNumber, episodeNumber: episodeNumber),
            responseModel: EpisodeDetailResponse.self
        )
    }
    
    func getSeasonDetail(seriesId: Int, seasonNumber: Int) async throws -> SeasonDetailResponse {
        
        return try await fetchRequest(
            endpoint: TmdbEndpoint.seasonDetail(seriesId: seriesId, seasonNumber: seasonNumber),
            responseModel: SeasonDetailResponse.self
        )
    }
}
