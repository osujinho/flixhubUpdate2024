//
//  Endpoint.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/9/24.
//

import Foundation

/**
 
 The path variable will be used as a complement to scheme and host to form the endpoint URL.
 It works like this: scheme + host + path.
 For instance: suppose the endpoint URL is https://api.themoviedb.org/3/movie/top_rated, then the path should be /3/movie/top_rated.
 
 */

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String? { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var parameters: [URLQueryItem]? { get }
}
