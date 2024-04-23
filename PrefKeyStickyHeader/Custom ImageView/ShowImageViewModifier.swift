//
//  ShowImageViewModifier.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/9/24.
//

import SwiftUI

struct ShowImageViewModifier: ViewModifier {
    
    @EnvironmentObject var fullImageViewModel: FullImageViewModel
    @State var bgOpacity: Double = 1.0
    private let bgColor: Color = AppAssets.backgroundColor
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if fullImageViewModel.showImageView {
                    ZStack {
                        bgColor
                            .ignoresSafeArea(edges: .all)
                            .opacity(bgOpacity)
                        
                        ImageView(bgOpacity: $bgOpacity)
                    }
                }
            }
            .animation(
                .linear
                , value: fullImageViewModel.showImageView
            )
    }
}

extension View {
    var showImageViewModifier: some View {
        modifier(ShowImageViewModifier())
    }
}

#Preview {
    ActorsListView(actors: mockActors)
}
