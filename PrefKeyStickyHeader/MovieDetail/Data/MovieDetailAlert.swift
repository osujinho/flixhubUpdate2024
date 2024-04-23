//
//  MovieDetailAlert.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/2/24.
//

import Foundation

enum MovieDetailAlert: ErrorAlertable {
    
    case loadingTmdbDetail(message: String)
    case loadingOmdbDetail(message: String)
    case loadingSimilar(message: String)
    case loadingRecommended(message: String)
    
    var id: MovieDetailAlert { self }
    
    var alertTitle: String {
        switch self {
        case .loadingTmdbDetail: return "Error Loading Movie Detail From TMDB"
        case .loadingOmdbDetail: return "Error Loading Movie Detail From OMDB"
        case .loadingSimilar: return "Error Loading Similar Movies"
        case .loadingRecommended: return "Error Loading Suggested Movies"
        }
    }
    
    var alertMessage: String {
        switch self {
        case.loadingTmdbDetail(let message), .loadingOmdbDetail(let message), .loadingSimilar(let message), .loadingRecommended(let message): return message
        }
    }
}
