//
//  CollectionGridRowBuilder.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/23/24.
//

import SwiftUI

struct GridRowBuilder<Item: Hashable, Content: View>: View {
    
    let label: String?
    let item: Item?
    let labelColor: Color
    let forAboutView: Bool
    let content: (Item) -> Content
    
    init(
        label: String?,
        item: Item?,
        labelColor: Color? = nil,
        forAboutView: Bool = false,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.label = label
        self.item = item
        self.labelColor = getLabelColor(labelColor: labelColor)
        self.forAboutView = forAboutView
        self.content = content
        
        func getLabelColor(labelColor: Color?) -> Color {
            let defaultColor = Color.secondary
            return labelColor ?? defaultColor
        }
    }
    
    var body: some View {
        
        if forAboutView {
            OptionalMethods.validOptionalBuilder(value: label) { label in
                GridRow(alignment: .top) {
                    
                    Text(label.removeExtraSpaces.capitalized)
                        .fontWeight(.bold)
                        .foregroundColor(labelColor)
                    
                    Group {
                        OptionalMethods.conditionalOptionalBuilder(item) { item in
                            content(item)
                        } else: {
                            Text(GlobalValues.defaultWrappedString)
                        }
                    }
                    .multilineTextAlignment(.leading)
                }
            }
        } else {
            GridRow(alignment: .top) {
                
                OptionalMethods.validOptionalBuilder(value: label) { label in
                    Text(label.removeExtraSpaces.capitalized)
                        .foregroundColor(labelColor)
                        .multilineTextAlignment(.leading)
                        .if(!item.isValid) { view in
                            view
                                .gridCellColumns(2)
                                .gridColumnAlignment(.leading)
                                .gridCellUnsizedAxes(.vertical)
                        }
                }
                
                OptionalMethods.validOptionalBuilder(value: item) { item in
                    content(item)
                        .multilineTextAlignment(.leading)
                        .if(!label.isValid) { view in
                            view
                                .gridCellColumns(2)
                                .gridColumnAlignment(.leading)
                                .gridCellUnsizedAxes(.vertical)
                        }
                }
            }
        }
    }
}
