//
//  ScrollScreenBuilder.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/8/24.
//

import SwiftUI

struct ScrollScreenBuilder<Content: View>: View {
    
    @State private var titleRect: CGRect = .zero
    let navBarData: NavBarData
    let content: Content
    
    init(navBarData: NavBarData, @ViewBuilder content: () -> Content) {
        self.navBarData = navBarData
        self.content = content()
    }
    
    var body: some View {
        
        CustomNavigationView(titleRect: titleRect, navBarData: navBarData) {
            ScrollView(.vertical, showsIndicators: false) {
                
                LazyVStack(alignment: .leading) {
                    Text(navBarData.title)
                        .font(.system(size: 25, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(GeometryGetter(rect: $titleRect))
                    
                    content
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical)
                }
                .padding(.horizontal)
                .padding(.vertical)
            }
        }
    }
}

#Preview {
    ContentView()
}
