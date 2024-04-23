//
//  LabelGridItemArray.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/27/24.
//

import Foundation

struct LabelGridItemArray: Hashable, Identifiable {
    var id = UUID().uuidString
    let label: String?
    let items: [String]?
    
    init(label: String?, items: [String]? = nil) {
        self.label = label
        self.items = items
    }
}
