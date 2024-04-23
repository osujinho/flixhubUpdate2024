//
//  CustomLoadingView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/10/24.
//

import SwiftUI

struct CustomLoadingView: View {
    
    @State var isLoading: Bool = false
    let lineWidth: CGFloat = 20
    var pathColor: Color = AppAssets.reverseBackground
    var lineColor: Color {
        pathColor
    }
    let width: CGFloat?
    let height: CGFloat?
    
    init(width: CGFloat? = 200, height: CGFloat? = 200) {
        self.width = width
        self.height = height
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(pathColor, lineWidth: lineWidth)
                .opacity(0.3)
            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(lineColor)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(
                    .linear(duration: 1)
                    .repeatForever(autoreverses: false)
                    , value: isLoading
                )
                .onAppear { self.isLoading.toggle() }
        }
        .frame(width: width, height: height)
        .padding()
    }
}

#Preview {
    CustomLoadingView()
}
