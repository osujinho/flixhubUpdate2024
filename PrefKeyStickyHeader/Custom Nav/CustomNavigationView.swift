////
////  CustomNavigationView.swift
////  PrefKeyStickyHeader
////
////  Created by Michael Osuji on 1/11/24.
////
//
import SwiftUI

struct CustomNavigationView<SearchBar: View, Content: View>: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    var titleRect: CGRect
    let navBarData: NavBarData
    let searchBarView: SearchBar
    let content: Content
    let searchBarIsEditing: Bool?
    private let bgColor: Color = AppAssets.backgroundColor
    var collapsedNavBarHeight: CGFloat {
        GlobalMethods.collapsedNavBarHeight(safeAreaInsets: safeAreaInsets)
    }
    
    init(
        titleRect: CGRect,
        navBarData: NavBarData,
        searchBarIsEditing: Bool?,
        @ViewBuilder searchBarView: () -> SearchBar,
        @ViewBuilder content: () -> Content
    ) {
        self.titleRect = titleRect
        self.navBarData = navBarData
        self.searchBarIsEditing = searchBarIsEditing
        self.searchBarView = searchBarView()
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            bgColor.ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                Color.clear
                    .frame(height: collapsedNavBarHeight)
                    .background(.ultraThinMaterial)
                    .opacity(isScrolledPastNavBar ? 1.0 : 0.01)
                    .blur(radius: 0.5)
                    .overlay(alignment: .top) {
                        
                        if let isEditing = searchBarIsEditing, isEditing {
                            searchBarView
                        } else {
                            CustomNavigationBarView(titleRect: titleRect, navBarData: navBarData) {
                                Text(navBarData.title)
                            }
                        }
                    }
                    .zIndex(1.0)
                
                content
            }
            .ignoresSafeArea(.all, edges: [.top])
        }
    }
    
    // MARK: - Helper functions
    private var isScrolledPastNavBar: Bool {
        titleRect.minY < collapsedNavBarHeight
    }
}

extension CustomNavigationView {
    init(titleRect: CGRect, navBarData: NavBarData, searchBarIsEditing: Bool? = nil, @ViewBuilder content: () -> Content) where SearchBar == EmptyView {
        self.init(
            titleRect: titleRect,
            navBarData: navBarData,
            searchBarIsEditing: searchBarIsEditing,
            searchBarView: { EmptyView() },
            content: content
        )
    }
}

#Preview {
    SearchView()
}
