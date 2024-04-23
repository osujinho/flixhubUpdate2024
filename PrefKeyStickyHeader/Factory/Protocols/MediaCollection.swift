//
//  MediaCollection.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/5/24.
//

import Foundation

protocol MediaCollection: Identifiable & Hashable & Codable {
    var id: Int { get }
    var name: String? { get }
    var poster: String? { get }
    var date: String? { get }
    var rating: Double? { get }
}
