//
//  GradientOverlayModifier.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 12/6/23.
//

import SwiftUI

struct GradientOverlayModifier: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(gradient: Gradient(colors: [.clear, color.opacity(1.0)]),
                               startPoint: .center,
                               endPoint: .bottom)
            )
    }
}

extension View {
    func gradientOverlayModifier(color: Color) -> some View {
        modifier(GradientOverlayModifier(color: color))
    }
}
