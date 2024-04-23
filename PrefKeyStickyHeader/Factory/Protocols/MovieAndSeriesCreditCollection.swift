//
//  MovieAndSeriesCreditCollection.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/12/24.
//

import Foundation

protocol MovieAndSeriesCreditCollection: MediaCollection {
    var picture: String? { get }
    var role: String? { get }
}

extension MovieAndSeriesCreditCollection {

    var poster: String? { picture }

    var date: String? { nil }

    var rating: Double? { nil }
}
