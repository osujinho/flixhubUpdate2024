//
//  OmdbEndpoint.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/10/24.
//

import Foundation

enum OmdbEndpoint {
    case movieDetail(id: String)
    case seriesDetail(id: String)
}

extension OmdbEndpoint: Endpoint {
    
    var scheme: String {
        "http"
    }
    
    var host: String {
        "www.omdbapi.com"
    }
    
    var path: String? {
        return "/"
    }
    
    var method: RequestMethod {
        .get
    }
    
    var header: [String : String]? {
        return nil
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .movieDetail(let id): return EndpointPairs.getQuerryItems(endpointPair: [.omdbApiKey, .omdbId(id: id)])
            
        case .seriesDetail(let id): return EndpointPairs.getQuerryItems(endpointPair: [.omdbApiKey, .omdbId(id: id)])
        }
    }
}
