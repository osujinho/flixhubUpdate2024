//
//  CustomNavigationBarView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/14/24.
//

import SwiftUI

struct CustomNavigationBarView<Content: View>: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.dismiss) private var dismiss
    var titleRect: CGRect
    var scrollOffset: CGFloat?
    var collapsedNavBarHeight: CGFloat {
        GlobalMethods.collapsedNavBarHeight(safeAreaInsets: safeAreaInsets)
    }
    let navBarData: NavBarData
    let content: Content
    
    private let backButtonIcon: String = "chevron.left"
    var topSafeArea: CGFloat {
        collapsedNavBarHeight / 2
    }
    var wrappedScrollOffset: CGFloat {
        scrollOffset ?? 0
    }
    var forParalax: Bool {
        scrollOffset != nil
    }
    var isPortrait: Bool {
        collapsedNavBarHeight > 50
    }
    var iconFontSize: CGFloat {
        20
    }
    
    init(titleRect: CGRect = .zero, scrollOffset: CGFloat? = nil, navBarData: NavBarData, @ViewBuilder content: () -> Content) {
        
        self.titleRect = titleRect
        self.scrollOffset = scrollOffset
        self.navBarData = navBarData
        self.content = content()
    }
    
    var body: some View {
        HStack {
            // back button
            
            Spacer()
                .overlay(alignment: .leading) {
                    if navBarData.hasBackButton {
                        NavIconButton(iconName: backButtonIcon, forParalax: forParalax) {
                            dismiss()
                        }
                    }
                }
            
            content
                .font(.system(size: titleFontSize, weight: .semibold))
                .foregroundColor(forParalax ? .white : .primary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal)
                .offset(x: 0, y: getHeaderTitleOffset())
            
            Spacer()
                .overlay(alignment: .trailing) {
                    if let trailingIcon = navBarData.trailingIcon {
                        NavIconButton(iconName: trailingIcon, iconColor: navBarData.trailingIconColor, forParalax: forParalax, action: navBarData.trailingAction)
                    }
                }
        }
        .padding(.horizontal)
        .padding(.top, topSafeArea)
        .padding(.bottom, isPortrait ? 0 : 10)
        .frame(height: collapsedNavBarHeight)
        .clipped()
        .offset(y: -wrappedScrollOffset)
    }
    
    private func getHeaderTitleOffset() -> CGFloat {
        let currentYPos = titleRect.midY
        
        // (x - min) / (max - min) -> Normalize our values between 0 and 1
        
        // If our Title has surpassed the bottom of our image at the top
        // Current Y POS will start at 75 in the beggining. We essentially only want to offset our 'Title' about 30px.
        
        if currentYPos < collapsedNavBarHeight {
            let minYValue: CGFloat = isPortrait ? topSafeArea * 1.2 : topSafeArea // What we consider our min for our scroll offset
            let maxYValue = isPortrait ? collapsedNavBarHeight : collapsedNavBarHeight * 0.8
            let currentYValue = currentYPos
            
            let percentage = max(-1, (currentYValue - maxYValue) / (maxYValue - minYValue)) // Normalize our values from 75 - 50 to be between 0 to -1, If scrolled past that, just default to -1
            let initialOffset: CGFloat = minYValue / 2
            
            // We will start at 20 pixels from the bottom (under our sticky header)
            // At the beginning, our percentage will be 0, with this resulting in 20 - (x * -30)
            // as x increases, our offset will go from 20 to 0 to -30, thus translating our title from 20px to -30px.
            return initialOffset + (percentage * initialOffset)
        }
        
        return .infinity
    }
    
    private var titleFontSize: CGFloat {
        if forParalax {
            return !navBarData.hasBackButton && navBarData.trailingIcon == nil ? 17 : 15
        } else {
            return 17
        }
    }
}

#Preview {
//    ContentView()
    //PlayersListView()
    MovieDetailView(movieId: 10195)
}
