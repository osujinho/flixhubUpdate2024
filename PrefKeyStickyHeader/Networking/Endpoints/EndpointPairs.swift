//
//  EndpointPairs.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/9/24.
//

import Foundation

enum EndpointPairs {
    
    case language, region, includeImageLanguage, appendToResponseMovie, appendToResponsePerson, appendToResponseSeries, omdbApiKey, episodeAndSeasonDetail, justImages, certificationCountry, watchRegion
    case page(page: Int)
    case query(query: String)
    case omdbId(id: String)
    case rapidMovieSearch(tmdbId: Int)
    case rapidTvSearch(tmdbId: Int)
    case certification(certification: String)
    case sortBy(criteria: String)
    case genres(genres: String)
    case lowestRating(rating: Int)
    case highestRating(rating: Int)
    case watchProvider(providers: String)
    case startReleaseDate(year: Int)
    case endReleaseDate(year: Int)
    case startAirDate(year: Int)
    case endAirDate(year: Int)
    
    private var key: String {
        switch self {
        case .language: return "language"
        case .region: return "region"
        case .watchRegion: return "watch_region"
        case .certificationCountry: return "certification_country"
        case .includeImageLanguage: return "include_image_language"
        case .appendToResponseMovie, .appendToResponsePerson, .appendToResponseSeries, .episodeAndSeasonDetail, .justImages: return "append_to_response"
        case .omdbApiKey: return "apikey"
        case .page: return "page"
        case .query: return "query"
        case .omdbId: return "i"
        case .rapidTvSearch, .rapidMovieSearch: return "tmdb_id"
        case .certification: return "certification"
        case .sortBy: return "sort_by"
        case .genres: return "with_genres"
        case .lowestRating: return "vote_average.gte"
        case .highestRating: return "vote_average.lte"
        case .watchProvider: return "with_watch_providers"
        case .startReleaseDate: return "primary_release_date.gte"
        case .endReleaseDate: return "primary_release_date.lte"
        case .startAirDate: return "first_air_date.gte"
        case .endAirDate: return "first_air_date.lte"
        }
    }
    
    private var value: String {
        switch self {
        case .language: return "en-US"
        case .region, .watchRegion: return "US"
        case .certificationCountry: return "us"
        case .includeImageLanguage: return "en,null"
        case .appendToResponseMovie: return "release_dates,watch/providers,credits,videos,images,reviews"
        case .appendToResponsePerson: return "tagged_images,combined_credits,images"
        case .appendToResponseSeries: return "content_ratings,watch/providers,credits,external_ids,videos,images,reviews"
        case .episodeAndSeasonDetail: return "images,videos,watch/providers"
        case .omdbApiKey: return "4324aa3d"
        case .page(let intValue), .highestRating(let intValue), .lowestRating(let intValue): return "\(intValue)"
        case .query(let stringValue), .omdbId(let stringValue), .certification(let stringValue), .sortBy(let stringValue), .genres(let stringValue), .watchProvider(let stringValue): return stringValue
        case .rapidMovieSearch(let id): return "movie/\(id)"
        case .rapidTvSearch(let id): return "tv/\(id)"
        case .justImages: return "images"
        case .startReleaseDate(let year), .startAirDate((let year)): return "\(year)-01-01"
        case .endReleaseDate(let year), .endAirDate((let year)): return "\(year)-12-31"
        }
    }
    
    static func getQuerryItems(endpointPair: [EndpointPairs]? = nil) -> [URLQueryItem] {
        
        var queryItems = [URLQueryItem]()
        
        if let endpointPair = endpointPair {
            for pair in endpointPair {
                let queryItem = URLQueryItem(name: pair.key, value: pair.value)
                queryItems.append(queryItem)
            }
        }
        return queryItems
    }
}
