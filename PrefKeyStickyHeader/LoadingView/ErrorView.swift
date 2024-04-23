//
//  ErrorView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/20/24.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack {
            Text("Error")
                .font(.title)
                .foregroundColor(.red)
            Text(message)
                .foregroundColor(.red)
        }
        .padding()
    }
}
