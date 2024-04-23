//
//  CustomModifier.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 12/1/23.
//

import SwiftUI

// Creates a conditional View Modifier based on a boolean
extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

/**
 
 .if(!viewModel.isLoading) { view in
     view
         .forgroundColor(.white)
 }
 
 */
