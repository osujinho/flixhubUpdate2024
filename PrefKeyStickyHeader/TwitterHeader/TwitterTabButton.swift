//
//  TwitterTabButton.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 12/8/23.
//

import SwiftUI

struct TwitterTabButton: View {
    
    var title: String
    @Binding var currentTab: String
    var animation: Namespace.ID
    private let matchedGeometryName: String = "TAB"
    
    var body: some View {
        Button(action: {
            withAnimation {
                currentTab = title
            }
        }, label: {
            
            VStack(spacing: 12) {
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(currentTab == title ? .blue : .gray)
                    .padding(.horizontal)
                
                if currentTab == title {
                    Capsule()
                        .fill(Color.blue)
                        .frame(height: 1.2)
                        .matchedGeometryEffect(id: matchedGeometryName, in: animation)
                } else {
                    Capsule()
                        .fill(Color.clear)
                        .frame(height: 1.2)
                }
            }
        })
    }
}
