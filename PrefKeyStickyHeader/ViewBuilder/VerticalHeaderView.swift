//
//  VerticalHeaderView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/20/24.
//

import SwiftUI

struct VerticalHeaderView: View {
    
    let header: String
    
    var body: some View {
        Text(header.capitalized)
            .font(.system(size: 15, weight: .bold))
            .padding(.vertical, 5)
    }
}

#Preview {
    VerticalHeaderView(header: "Label")
}
