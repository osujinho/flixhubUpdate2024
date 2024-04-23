//
//  PersonDetailOption.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/29/24.
//

import Foundation

enum PersonDetailOptions: EnumPickable {
    case about, movies, shows, crewMovies, crewShows
    
    var id: PersonDetailOptions { self }
    
    var description: String {
        switch self {
        case .about: return "About"
        case .movies: return "Cast Movies"
        case .shows: return "Cast Shows"
        case .crewMovies: return "Crew Movies"
        case .crewShows: return "Crew Shows"
        }
    }
}
