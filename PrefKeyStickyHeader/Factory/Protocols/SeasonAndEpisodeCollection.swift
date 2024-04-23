//
//  SeasonAndEpisodeCollection.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/14/24.
//

import Foundation

protocol SeasonAndEpisodeCollection: MediaCollection {
    var image: String? { get }
    var airDate: String? { get }
}
