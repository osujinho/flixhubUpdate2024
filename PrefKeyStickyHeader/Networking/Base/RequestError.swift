//
//  RequestError.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/9/24.
//

import Foundation

enum RequestError: Error {
    case invalidURL
    case requestFailed
    case responseUnsuccessful(description: String)
    case jsonConversionFailure(description: String)
    case unauthorized
    case unknown
    
    var customMessage: String {
        switch self {
        case .requestFailed: return "Request Failed: Invalid Response"
        case let .jsonConversionFailure(description): return "JSON Conversion Failure: \(description)"
        case let .responseUnsuccessful(description): return "Unsuccessful: \(description)"
        case .unauthorized:
            return "Session expired"
        default:
            return "Unknown error"
        }
    }
    
    static func getMessage(error: Error) -> String {
        var message: String = ""
        
        if let requestError = error as? RequestError {
            message = requestError.customMessage
            print(requestError)
        } else {
            // Handle unexpected errors
            message = "An unexpected error occurred."
            print("Unexpected error: \(error)")
        }
        return message
    }
}
