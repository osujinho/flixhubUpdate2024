//
//  NavigateToView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/3/24.
//

import SwiftUI

struct NavigateToView<Label, Destination>: View where Label : View, Destination : View {
    
    let destination: Destination
    let label: Label
    
    init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination()
        self.label = label()
    }
    
    var body: some View {
        NavigationLink {
            destination
                .navigationBarHidden(true)
        } label: {
            label
        }
    }
}
