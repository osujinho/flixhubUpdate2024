//
//  TmdbMedia.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/11/24.
//

import Foundation

protocol TmdbMedia: Identifiable & Hashable & Codable {
    var id: Int { get }
    var name: String? { get }
    var poster: String? { get }
    var date: String? { get }
    var rating: Double? { get }
    var plot: String? { get }
}
