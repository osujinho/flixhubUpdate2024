//
//  CustomEmptyView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/20/24.
//

import SwiftUI

struct CustomEmptyView: View {
    
    let message: String
    
    var body: some View {
        VStack{
            Spacer()
            Text(message)
                .font(.title)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}
