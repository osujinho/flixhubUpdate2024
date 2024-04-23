//
//  VerticalLabelContainerBuilder.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/21/24.
//

import SwiftUI

struct VerticalLabelContainerBuilder<Content: View>: View {
    
    let header: String
    let content: Content
    
    init(
        header: String,
        @ViewBuilder content: () -> Content
    ) {
        self.header = header
        self.content = content()
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            VerticalHeaderView(header: header)
            
            VStack(alignment: .leading, spacing: 10){
                content
            }
            .font(.system(size: 13))
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}
