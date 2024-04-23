//
//  RemoveExtraSpaces.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/8/24.
//

import Foundation

extension String {
    var removeExtraSpaces: String {
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalString = trimmedString.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        return finalString
    }
}
