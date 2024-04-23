//
//  SearchAlert.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/6/24.
//

import Foundation

enum SearchAlert: ErrorAlertable {
    
    case loadingMovies(message: String)
    case loadingSeries(message: String)
    case loadingPeople(message: String)
    
    var id: SearchAlert { self }
    
    var alertTitle: String {
        switch self {
        case .loadingMovies: return "Error Loading Movies"
        case .loadingSeries: return "Error Loading Series"
        case .loadingPeople: return "Error Loading People"
        }
    }
    
    var alertMessage: String {
        switch self {
        case .loadingMovies(let message), .loadingSeries(let message), .loadingPeople(let message): return message
        }
    }
}
