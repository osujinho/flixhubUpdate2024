//
//  SeperatorView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 12/30/23.
//

import SwiftUI

struct SeperatorView: View {
    
    let width: CGFloat = 8
    var iconBgColor: Color = AppAssets.reverseBackground
    
    var body: some View {
        Text("•")
            .font(.system(size: 22))
            .foregroundColor(iconBgColor)
            .frame(width: width, height: width)
    }
}

#Preview {
    SeperatorView()
}
