//
//  BlurViewModifier.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 12/27/23.
//

import SwiftUI

struct BlurViewModifier: ViewModifier {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    var collapsedNavBarHeight: CGFloat {
        GlobalMethods.collapsedNavBarHeight(safeAreaInsets: safeAreaInsets)
    }
    var scrollOffset: CGFloat
    let backdropHeight: CGFloat
    
    var sizeOffScreen: CGFloat {
        backdropHeight - collapsedNavBarHeight
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            CustomBlurView()
                .opacity(blurOpacity)
        }
    }
    
    private var blurOpacity: Double {
        let progress = (scrollOffset + (collapsedNavBarHeight * 0.7)) / -sizeOffScreen
        return Double(-scrollOffset > collapsedNavBarHeight ? progress : 0)
    }
}

extension View {
    func blurViewModifier(scrollOffset: CGFloat, backdropHeight: CGFloat) -> some View {
        modifier(BlurViewModifier(scrollOffset: scrollOffset, backdropHeight: backdropHeight))
    }
}

#Preview {
    MovieDetailView(movieId: 545609)
}
