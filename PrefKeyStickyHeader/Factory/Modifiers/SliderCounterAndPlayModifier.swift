//
//  SliderCounterAndPlayModifier.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 12/13/23.
//

import SwiftUI

struct SliderCounterAndPlayModifier: ViewModifier {
    
    let fontColor: Color
    let bgColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(fontColor)
            .padding(.vertical, 2)
            .padding(.horizontal, 5)
            .background(bgColor.cornerRadius(5))
    }
}

extension View {
    func sliderCounterAndPlayModifier(fontColor: Color = .white, bgColor: Color = Color.black.opacity(0.6)) -> some View {
        modifier(SliderCounterAndPlayModifier(fontColor: fontColor, bgColor: bgColor))
    }
}
