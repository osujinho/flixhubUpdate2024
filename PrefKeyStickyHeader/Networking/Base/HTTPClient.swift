//
//  HTTPClient.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/9/24.
//

import Foundation

protocol HTTPClient {
    func fetchRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T
}

extension HTTPClient {
    
    func fetchRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        if let path = endpoint.path {
            urlComponents.path = path
        }
        urlComponents.queryItems = endpoint.parameters
        
        guard let url = urlComponents.url else { throw RequestError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RequestError.requestFailed
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw RequestError.responseUnsuccessful(description: "Status code: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(responseModel, from: data)
        } catch {
            print(error)
            throw RequestError.jsonConversionFailure(description: error.localizedDescription)
        }
    }
}
