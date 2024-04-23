//
//  SortMediaCollection.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/8/24.
//

import Foundation

extension Array where Element: MediaCollection {
    func sortByDate() -> [Element] {
        return self.sorted {
            guard let date1 = $0.date, let date2 = $1.date else {
                return false // Or true, depending on how you want to handle nil dates
            }
            return date1 > date2
        }
    }
}

/**
 
    How to Use it
     let movies: [PersonCastMovie] = // Your array of PersonCastMovie objects
     let sortedMovies = movies.sortByDate()

     let shows: [PersonCastShow] = // Your array of PersonCastShow objects
     let sortedShows = shows.sortByDate()

     let crewMovies: [PersonCrewMovie] = // Your array of PersonCrewMovie objects
     let sortedCrewMovies = crewMovies.sortByDate()

     let crewShows: [PersonCrewShow] = // Your array of PersonCrewShow objects
     let sortedCrewShows = crewShows.sortByDate()
 
 */
