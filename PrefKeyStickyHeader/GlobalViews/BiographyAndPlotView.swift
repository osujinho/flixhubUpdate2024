//
//  BiographyAndPlotView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/17/24.
//

import SwiftUI

struct BiographyAndPlotView: View {
    
    @State private var isExpanded = false
    @State private var screenWidth: CGFloat = 0
    let overview: String?
    let header: String
    
    var body: some View {
        
        VerticalLabelContainerBuilder(header: header) {
            
            OptionalMethods.conditionalOptionalBuilder(overview) { overview in
                VStack(alignment: .leading) {
                    Text(overview)
                        .lineLimit(isExpanded ? nil : 3)
                        .readSize { screenSize in
                            self.screenWidth = screenSize.width
                        }
                    
                    if isLongerThanThreeLines {
                        Button(action: {
                            withAnimation(.linear) {
                                isExpanded.toggle()
                            }
                        }) {
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .foregroundColor(isExpanded ? .red.opacity(0.8) : .blue.opacity(0.8))
                                .padding(.top, 5)
                        }
                    }
                }
            } else: {
                Text(GlobalValues.defaultWrappedString)
            }
        }
    }
    
    private var isLongerThanThreeLines: Bool {
        let screenWidthLessPadding = (screenWidth - 40)
        return (overviewWidth / screenWidthLessPadding) > 3
    }
    
    private var overviewWidth: CGFloat {
        let defaultWidth = GlobalValues.defaultWrappedString.widthOfString(usingFont: UIFont.systemFont(ofSize: 13))
        guard let overview = overview else { return defaultWidth }
        let overviewLength = overview.widthOfString(usingFont: UIFont.systemFont(ofSize: 13))
        return overviewLength
    }
}
