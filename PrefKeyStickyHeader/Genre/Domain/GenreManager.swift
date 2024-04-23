//
//  GenreManager.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/17/24.
//

import Foundation

struct GenreManager {
    
    static func getGenres(genreIDs: [Int]?, isMovie: Bool) -> String {
        
        guard let genreIDs = genreIDs, !genreIDs.isEmpty else { return GlobalValues.defaultWrappedString }
        let genres: [any IntIdentifiable] = isMovie ? MovieGenre.allCases : SeriesGenre.allCases
        let genreNames = genreIDs.compactMap { id in
            genres.first(where: { $0.id == id })?.description
        }
        return genreNames.joined(separator: ", ")
    }
    
    #warning("Might have to delete once discovery is implemented")
    static func getGenreIds<MediaGenre: IntIdentifiable>(for genres: [MediaGenre]) -> String {
        let rawValues = genres.map { String($0.id) }
        return rawValues.joined(separator: ",")
    }
    
    static func firstThree(genreIds: [Int]?, isMovie: Bool) -> String? {
        guard let genreIds = genreIds, !genreIds.isEmpty else { return nil }
        let topThree = Array(genreIds.prefix(3))
        return getGenres(genreIDs: topThree, isMovie: isMovie)
    }
}
