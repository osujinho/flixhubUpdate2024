//
//  ArrayInGridView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/27/24.
//

import SwiftUI

struct ArrayInGridView: View {
    
    let label: String
    let items: [String]?
    let forDetailView: Bool
    
    // Initializer for when forDetailView is true
    init(label: String, items: [String]?) {
        self.label = label
        self.items = items
        self.forDetailView = true
    }
    
    // Initializer for when forDetailView is false
    init(items: [String]?) {
        self.label = ""
        self.items = items
        self.forDetailView = false
    }
    
    var body: some View {
        if forDetailView {
            GridRowBuilder(label: label.capitalized, item: items, forAboutView: true) { items in
                VStack(alignment: .leading) {
                    ForEach(items, id: \.self) { item in
                        Text(item.removeExtraSpaces)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        } else {
            OptionalMethods.validOptionalBuilder(value: items) { items in
                Grid(alignment: .topLeading,
                     horizontalSpacing: 5,
                     verticalSpacing: 5) {
                    
                    ForEach(items, id: \.self) { item in
                        GridRow {
                            Text("•")
                            Text(item.removeExtraSpaces)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
            }
        }
    }
}
