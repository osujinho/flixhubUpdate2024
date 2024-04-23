//
//  MpaRatingView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 12/1/23.
//

import SwiftUI

struct MpaRatingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    let rated: String?
    let isInline: Bool
    let fontColor: Color = .secondary
    
    var width: CGFloat {
        rated != nil ? 50 : 70
    }
    var height: CGFloat {
        isInline ? 20 : 25
    }
    
    init(rated: String?, isInline: Bool = false) {
        self.rated = rated
        self.isInline = isInline
    }
    
    var body: some View {
        Text(rated ?? "Not Rated")
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(fontColor)
            .frame(width: width, height: height)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(fontColor, lineWidth: 2)
            )
    }
}

#Preview {
    MpaRatingView(rated: nil)
}
