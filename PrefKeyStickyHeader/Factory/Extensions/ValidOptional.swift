//
//  ValidOptional.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/23/24.
//

import SwiftUI

extension Optional {
    var isValid: Bool {
        guard let unwrappedValue = self else { return false }
        
        switch unwrappedValue {
        case let string as String:
            return !GlobalValues.unwantedStrings.contains(string)
        case let double as Double:
            return double > 0
        case let int as Int:
            return int > 0
        case let collection as any ForEachCollection:
            return !collection.isEmpty
        default:
            return true
        }
    }
}
