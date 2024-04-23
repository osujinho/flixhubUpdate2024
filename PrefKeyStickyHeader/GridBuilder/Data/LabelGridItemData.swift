//
//  LabelGridItemData.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/12/24.
//

import Foundation

struct LabelGridItemData: Hashable, Identifiable {
    var id = UUID().uuidString
    let label: String?
    let content: String?
    
    init(label: String?, content: String? = nil) {
        self.label = label
        self.content = content
    }
}
