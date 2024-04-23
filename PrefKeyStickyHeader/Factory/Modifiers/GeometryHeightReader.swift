//
//  GeometryHeightReader.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/21/24.
//

import SwiftUI

struct GeometryHeightReader: ViewModifier {
    
    @Binding var height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(GeometryReader { proxy -> Color in
                DispatchQueue.main.async {
                    self.height = proxy.size.height
                }
                return Color.clear
            })
    }
}

extension View {
    func geometryHeightReader(height: Binding<CGFloat>) -> some View {
        modifier(GeometryHeightReader(height: height))
    }
}
