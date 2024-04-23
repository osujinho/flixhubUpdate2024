//
//  MediaOption.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/5/24.
//

import Foundation

enum MediaOption: EnumPickable {
    case movie, series
    
    var id: MediaOption { self }
    
    var description: String {
        switch self {
        case .movie: return "Movies"
        
        case .series: return "TV Shows"
        }
    }
}
