//
//  MoviesEndpoint.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/9/24.
//

import Foundation

enum TmdbEndpoint {
    case upcoming(page: Int)
    case nowPlaying(page: Int)
    case popular(page: Int)
    case topRated(page: Int)
    case trendingMovies(page: Int)
    
    case movieDetail(id: Int)
    case similarMovies(id: Int, page: Int)
    case recommendedMovies(id: Int, page: Int)
    case belongsToCollection(collectionId: Int)
    
    case personDetail(id: Int)
    case trendingPeople(page: Int)
    
    case seriesDetail(id: Int)
    case similarSeries(id: Int, page: Int)
    case recommendedSeries(id: Int, page: Int)
    
    case airingToday(page: Int)
    case onTheAir(page: Int)
    case popularSeries(page: Int)
    case topRatedSeries(page: Int)
    case trendingSeries(page: Int)
    
    case episodeDetail(seriesId: Int, seasonNumber: Int, episodeNumber: Int)
    case seasonDetail(seriesId: Int, seasonNumber: Int)
    
    case searchMovie(query: String, page: Int)
    case searchSeries(query: String, page: Int)
    case searchPerson(query: String, page: Int)
    
    case discoverMovie(movieDiscoveryData: MovieDiscoveryData)
    case discoverSeries(seriesDiscoveryData: SeriesDiscoveryData)
}

extension TmdbEndpoint: Endpoint {
    
    var scheme: String {
        return "https"
    }

    var host: String {
        return "api.themoviedb.org"
    }
    
    var path: String? {
        switch self {
        case .upcoming: return "/3/movie/upcoming"
        case .nowPlaying: return "/3/movie/now_playing"
        case .popular: return "/3/movie/popular"
        case .topRated: return "/3/movie/top_rated"
        case .trendingMovies: return "/3/trending/movie/day"
            
        case .movieDetail(let id): return "/3/movie/\(id)"
        case .similarMovies(let id, _): return "/3/movie/\(id)/similar"
        case .recommendedMovies(let id, page: _): return "/3/movie/\(id)/recommendations"
        case .belongsToCollection(let id): return "/3/collection/\(id)"
            
        case .personDetail(let id): return "/3/person/\(id)"
        case .trendingPeople: return "/3/trending/person/day"
            
        case .seriesDetail(let id): return "/3/tv/\(id)"
        case .similarSeries(let id, _): return "/3/tv/\(id)/similar"
        case .recommendedSeries(let id, _): return "/3/tv/\(id)/recommendations"
            
        case .airingToday: return "/3/tv/airing_today"
        case .onTheAir: return "/3/tv/on_the_air"
        case .popularSeries: return "/3/tv/popular"
        case .topRatedSeries: return "/3/tv/top_rated"
        case .trendingSeries: return "/3/trending/tv/day"
            
        case.seasonDetail(let seriesId, let seasonNumber): return "/3/tv/\(seriesId)/season/\(seasonNumber)"
        case .episodeDetail(let seriesId, let seasonNumber, let episodeNumber): return "/3/tv/\(seriesId)/season/\(seasonNumber)/episode/\(episodeNumber)"
        
        case .searchMovie: return "/3/search/movie"
        case .searchSeries: return "/3/search/tv"
        case .searchPerson: return "/3/search/person"
            
        case .discoverMovie: return "/3/discover/movie"
        case .discoverSeries: return "/3/discover/tv"
        }
    }

    var method: RequestMethod {
        switch self {
        default:
            return .get
        }
    }

    var header: [String: String]? {
        // Access Token to use in Bearer header
        let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMDI3M2M1MWUzZTJlMzNjY2YzMDg3NDg1MGM1ZTNiNSIsInN1YiI6IjYxZmQ4OTcwNWFkNzZiMDAyMDMzZGQyOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.XFQwzbtIKumx6ESzNxycRE8N0oLyqSBKisPomwhSx04"
        switch self {
        default:
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json;charset=utf-8",
                "accept": "application/json"
            ]
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .upcoming(let page), .nowPlaying(let page), .popular(let page), .topRated(let page):
            return EndpointPairs.getQuerryItems(endpointPair: [.language, .page(page: page)])
            
        case .recommendedMovies(_, let page), .recommendedSeries(_, let page), .similarMovies(_, let page), .similarSeries(_, let page), .airingToday(let page), .onTheAir(let page), .popularSeries(let page), .topRatedSeries(let page), .trendingSeries(let page), .trendingMovies(let page), .trendingPeople(let page):
            return EndpointPairs.getQuerryItems(endpointPair: [.page(page: page)])
            
        case .movieDetail:
            return EndpointPairs.getQuerryItems(endpointPair: [.appendToResponseMovie, .includeImageLanguage])
            
        case .belongsToCollection: return EndpointPairs.getQuerryItems(endpointPair: [.justImages, .includeImageLanguage])
            
        case .personDetail:
            return EndpointPairs.getQuerryItems(endpointPair: [.language, .appendToResponsePerson])
            
        case .seriesDetail:
            return EndpointPairs.getQuerryItems(endpointPair: [.appendToResponseSeries, .includeImageLanguage])
    
        case .searchMovie(let query, let page), .searchSeries(let query, let page), .searchPerson(let query, let page):
            return EndpointPairs.getQuerryItems(endpointPair: [.query(query: query), .page(page: page), .language])
            
        case .seasonDetail, .episodeDetail: return EndpointPairs.getQuerryItems(endpointPair: [.episodeAndSeasonDetail, .includeImageLanguage])
            
        case .discoverMovie(let discoveryData):
            
            return discoverQueryItems(certification: discoveryData.certification, genres: discoveryData.genres, lowestRating: discoveryData.lowestRating, highestRating: discoveryData.highestRating, watchProvider: discoveryData.watchProvider, startReleaseYear: discoveryData.startReleaseYear, endReleaseYear: discoveryData.endReleaseYear, sortBy: discoveryData.sortBy, page: discoveryData.page)
            
        case .discoverSeries(let discoveryData):
            
            return discoverQueryItems(genres: discoveryData.genres, lowestRating: discoveryData.lowestRating, highestRating: discoveryData.highestRating, watchProvider: discoveryData.watchProvider, startAirYear: discoveryData.startAirYear, endAirYear: discoveryData.endAirYear, sortBy: discoveryData.sortBy, page: discoveryData.page)
        }
    }
    
    private func discoverQueryItems(certification: String? = nil, genres: (any AndOrSelectable)? = nil, lowestRating: Int? = nil, highestRating: Int? = nil, watchProvider: (any AndOrSelectable)? = nil, startReleaseYear: Int? = nil, endReleaseYear: Int? = nil, startAirYear: Int? = nil, endAirYear: Int? = nil, sortBy: SortCriteriaOption, page: Int) -> [URLQueryItem] {
        
        var pairs: [EndpointPairs] = [
            .language,
            .sortBy(criteria: sortBy.description),
            .page(page: page)
        ]
        
        if let certification = certification {
            pairs += [.certification(certification: certification), .region, .certificationCountry]
        }
        
        if let genres = genres {
            pairs.append(.genres(genres: genres.formattedValue))
        }
        
        if let lowestRating = lowestRating {
            pairs.append(.lowestRating(rating: lowestRating))
        }
        
        if let highestRating = highestRating {
            pairs.append(.highestRating(rating: highestRating))
        }
        
        if let watchProvider = watchProvider {
            pairs += [.watchProvider(providers: watchProvider.formattedValue), .watchRegion]
        }
        
        if let startReleaseYear = startReleaseYear {
            pairs.append(.startReleaseDate(year: startReleaseYear))
        }
        
        if let endReleaseYear = endReleaseYear {
            pairs.append(.endReleaseDate(year: endReleaseYear))
        }
        
        if let startAirYear = startAirYear {
            pairs.append(.startAirDate(year: startAirYear))
        }
        
        if let endAirYear = endAirYear {
            pairs.append(.endAirDate(year: endAirYear))
        }
        
        return EndpointPairs.getQuerryItems(endpointPair: pairs)
    }
}
