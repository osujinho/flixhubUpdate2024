//
//  YearData.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/11/24.
//

import Foundation

enum YearData: Pickable {
    case year(Int)

    var id: Int {
        switch self {
        case .year(let value):
            return value
        }
    }

    var description: String {
        switch self {
        case .year(let value):
            return String(value)
        }
    }
}

// Create an extension to generate years from 1899 to the current year
extension YearData {
    static var currentYear: Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: Date())
    }

    static var allYears: [YearData] {
        let currentYear = Self.currentYear
        return (1899...currentYear).map { YearData.year($0) }.reversed()
    }
}
