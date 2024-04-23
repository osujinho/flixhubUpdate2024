//
//  GridContainer.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/25/24.
//

import SwiftUI

struct GridContainer<Content: View>: View {
    
    let forAboutView: Bool
    let content: Content
    let horizontalSpacing: CGFloat = 30
    var verticalSpacing: CGFloat {
        forAboutView ? 10 : 5
    }
    
    init(forAboutView: Bool = false, @ViewBuilder content: () -> Content) {
        self.forAboutView = forAboutView
        self.content = content()
    }
    
    var body: some View {
        Grid(alignment: .topLeading,
                     horizontalSpacing: horizontalSpacing,
             verticalSpacing: verticalSpacing) {
            
            content
        }
    }
}
