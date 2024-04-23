//
//  RapidEndpoint.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/21/24.
//

import Foundation

enum RapidEndpoint {
    case movie(tmdbId: Int)
    case tv(tmdbId: Int)
}

extension RapidEndpoint: Endpoint {
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "streaming-availability.p.rapidapi.com"
    }
    
    var path: String? {
        "/get"
    }
    
    var method: RequestMethod {
        return .get
    }
    
    var header: [String : String]? {
        let apiKey = "472574cb35msh6e08f1ee20cd087p16e6c4jsn9f7ff58b7997"
        let host = "streaming-availability.p.rapidapi.com"
        
        return [
            "X-RapidAPI-Key": apiKey,
            "content-type": "application/json"
        ]
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .movie(let tmdbId):
            return EndpointPairs.getQuerryItems(endpointPair: [.rapidMovieSearch(tmdbId: tmdbId)])
        case .tv(let tmdbId):
            return EndpointPairs.getQuerryItems(endpointPair: [.rapidTvSearch(tmdbId: tmdbId)])
        }
    }
}
