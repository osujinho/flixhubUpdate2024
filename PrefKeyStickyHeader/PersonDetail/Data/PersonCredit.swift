//
//  PersonCreditData.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/29/24.
//

import Foundation

struct PersonCreditData: Hashable, Codable {
    
    var movieCasts: [PersonCastMovie]?
    var tvCasts: [PersonCastSeries]?
    var movieCrews: [PersonCrewMovie]?
    var tvCrews: [PersonCrewSeries]?
    
    init(credit: PersonResponse.Credit?) {
        
        self.movieCasts = CreditManager.mergeKnownCredits( credit?.cast.compactMap { cast -> PersonCastMovie? in
            if case let .movie(movie) = cast {
                return movie
            }
            return nil
        })?.sortByDate()
        
        self.tvCasts = CreditManager.mergeKnownCredits( credit?.cast.compactMap { cast -> PersonCastSeries? in
            if case let .tv(show) = cast {
                return show
            }
            return nil
        })?.sortByDate()
        
        self.movieCrews = CreditManager.mergeKnownCredits( credit?.crew.compactMap { cast -> PersonCrewMovie? in
            if case let .movie(movie) = cast {
                return movie
            }
            return nil
        })?.sortByDate()
        
        self.tvCrews = CreditManager.mergeKnownCredits( credit?.crew.compactMap { cast -> PersonCrewSeries? in
            if case let .tv(show) = cast {
                return show
            }
            return nil
        })?.sortByDate()
    }
}

struct PersonCastMovie: PersonCreditCollection {
    let id: Int
    let genreIds: [Int]?
    let poster: String?
    let rating: Double?
    let mediaType: String?
    let title: String?
    let releaseDate: String?
    let character: String?
    
    var name: String? { title }
    var date: String? { releaseDate }
    var role: String? { character }
    
    private enum CodingKeys: String, CodingKey {
        case id, title, character
        case genreIds = "genre_ids"
        case poster = "poster_path"
        case rating = "vote_average"
        case mediaType = "media_type"
        case releaseDate = "release_date"
    }
}

struct PersonCastSeries: PersonCreditCollection {
    let id: Int
    let genreIds: [Int]?
    let poster: String?
    let rating: Double?
    let mediaType: String?
    let name: String?
    let firstAirDate: String?
    let character: String?
    
    var date: String? { firstAirDate }
    var role: String? { character }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, character
        case genreIds = "genre_ids"
        case poster = "poster_path"
        case rating = "vote_average"
        case mediaType = "media_type"
        case firstAirDate = "first_air_date"
    }
}

struct PersonCrewMovie: PersonCreditCollection {
    let id: Int
    let genreIds: [Int]?
    let poster: String?
    let rating: Double?
    let mediaType: String?
    let title: String?
    let releaseDate: String?
    let job: String?
    
    var name: String? { title }
    var date: String? { releaseDate }
    var role: String? { job }
    
    private enum CodingKeys: String, CodingKey {
        case id, title, job
        case genreIds = "genre_ids"
        case poster = "poster_path"
        case rating = "vote_average"
        case mediaType = "media_type"
        case releaseDate = "release_date"
    }
}

struct PersonCrewSeries: PersonCreditCollection {
    let id: Int
    let genreIds: [Int]?
    let poster: String?
    let rating: Double?
    let mediaType: String?
    let name: String?
    let firstAirDate: String?
    let job: String?
    
    var date: String? { firstAirDate }
    var role: String? { job }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, job
        case genreIds = "genre_ids"
        case poster = "poster_path"
        case rating = "vote_average"
        case mediaType = "media_type"
        case firstAirDate = "first_air_date"
    }
}
