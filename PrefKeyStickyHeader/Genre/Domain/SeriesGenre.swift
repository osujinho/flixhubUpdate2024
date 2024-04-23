//
//  SeriesGenre.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/7/24.
//

import Foundation

enum SeriesGenre: Int, IntIdentifiable {
    
    case actionAndAdventure = 10759
    case animation = 16
    case comedy = 35
    case crime = 80
    case documentary = 99
    case drama = 18
    case family = 10751
    case kids = 10762
    case mystery = 9648
    case news = 10763
    case reality = 10764
    case sciFiAndFantasy = 10765
    case soap = 10766
    case talk = 10767
    case warAndPolitics = 10768
    case western = 37

    var id: Int { self.rawValue }
    
    var description: String {
        switch self {
        case .actionAndAdventure: return "Action & Adventure"
        
        case .animation: return "Animation"
        
        case .comedy: return "Comedy"
        
        case .crime: return "Crime"
        
        case .documentary: return "Documentary"
        
        case .drama: return "Drama"
        
        case .family: return "Family"
            
        case .kids: return "Kids"
            
        case .mystery: return "Mystery"
            
        case .news: return "News"
            
        case .reality: return "Reality"
            
        case .sciFiAndFantasy: return "Sci-Fi & Fantasy"
            
        case .soap: return "Soap"
            
        case .talk: return "Talk"
            
        case .warAndPolitics: return "War & Politics"
            
        case .western: return "Western"
        }
    }
}
