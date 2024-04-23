//
//  RatingData.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/21/24.
//

import Foundation

// Conforming to Pickable (Identifiable, Hashable, CustomStringConvertible)
enum RatingData: Pickable {
    case rating(Int)

    // Identifiable conformance
    var id: Int {
        switch self {
        case .rating(let value):
            return value
        }
    }

    // CustomStringConvertible conformance
    var description: String {
        switch self {
        case .rating(let value):
            return String(value)
        }
    }
}

// Extension to generate a range of ratings
extension RatingData {
    static var allRatings: [RatingData] {
        return (1...10).reversed().map { .rating($0) }
    }
}
