//
//  GridRowSubView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/14/24.
//

import SwiftUI

enum GridRowSubView {
    
    @ViewBuilder
    static func CollectionGridView(items: [LabelGridItemData]) -> some View {
        GridContainer {
            ForEach(items, id: \.self) { item in
                GridRowBuilder(label: item.label, item: item.content) { content in
                    Text(content.removeExtraSpaces)
                }
            }
        }
    }
    
    @ViewBuilder
    static func SingleStringView(text: String?) -> some View {
        OptionalMethods.validOptionalBuilder(value: text) { text in
            Text(text.removeExtraSpaces)
                .multilineTextAlignment(.leading)
        }
    }
    
    @ViewBuilder
    static func BuildGridRows(for items: [LabelGridItemData]) -> some View {
        ForEach(items) { item in
            GridRowBuilder(label: item.label, item: item.content, forAboutView: true) { content in
                Text(content.removeExtraSpaces)
            }
        }
    }
    
    @ViewBuilder
    static func BuildGridRowForArray(for item: LabelGridItemArray?) -> some View {
        OptionalMethods.validOptionalBuilder(value: item?.label) { label in
            ArrayInGridView(label: label, items: item?.items)
        }
    }
}
