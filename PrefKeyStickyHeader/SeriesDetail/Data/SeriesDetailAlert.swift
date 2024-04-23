//
//  SeriesDetailAlert.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/14/24.
//

import Foundation

enum SeriesDetailAlert: ErrorAlertable {
    
    case loadingTmdbDetail(message: String)
    case loadingOmdbDetail(message: String)
    case loadingSimilar(message: String)
    case loadingRecommended(message: String)
    
    var id: SeriesDetailAlert { self }
    
    var alertTitle: String {
        switch self {
        case .loadingTmdbDetail: return "Error Loading Series Detail From TMDB"
        case .loadingOmdbDetail: return "Error Loading Series Detail From OMDB"
        case .loadingSimilar: return "Error Loading Similar Series"
        case .loadingRecommended: return "Error Loading Suggested Series"
        }
    }
    
    var alertMessage: String {
        switch self {
        case.loadingTmdbDetail(let message), .loadingOmdbDetail(let message), .loadingSimilar(let message), .loadingRecommended(let message): return message
        }
    }
}
