//
//  OnTapGestureModifier.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/9/24.
//

import SwiftUI

struct OnTapGestureModifier: ViewModifier {
    
    let count: Int
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .onTapGesture(count: count, perform: {
                action()
            })
    }
}

extension View {
    func onTapGestureModifier(count: Int = 1, action: @escaping () -> Void) -> some View {
        modifier(OnTapGestureModifier(count: count, action: action))
    }
}
