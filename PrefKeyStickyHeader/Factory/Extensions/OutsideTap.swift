//
//  OutsideTap.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/12/24.
//

import SwiftUI

/**
 
    How to Use
 
         SomeView()
             .onTapBackground(set: $isShowingAlert)
 */

struct OnTapOutsideViewModifier: ViewModifier {
    
    let action: () -> Void
    
    func body(content: Content) -> some View {
        
        ZStack {
            
            // Overlay view to detect taps outside the TextView
            Color.clear
                //.frame(width: 300, height: 300)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGestureModifier {
                    action()
                }
            
            // Your content goes here
            content
        }
    }
}

extension View {
    func onTapOutsideView(action: @escaping () -> Void) -> some View {
        self.modifier(OnTapOutsideViewModifier(action: action))
    }
}
