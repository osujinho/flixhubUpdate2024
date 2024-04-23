//
//  CustomBlurView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 12/8/23.
//

import SwiftUI

struct CustomBlurView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

#Preview {
    MovieDetailView(movieId: 545609)
}
