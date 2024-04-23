//
//  IconButton.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/13/24.
//

import SwiftUI

struct NavIconButton: View {
    
    let iconName: String
    let iconColor: Color?
    let forParalax: Bool
    let action: (() -> ())?
    
    let circleWidth: CGFloat
    var iconFontSize: CGFloat {
        forParalax ? (circleWidth - 10) : 20
    }
    
    init(
        iconName: String,
        iconColor: Color? = nil,
        forParalax: Bool = false,
        circleWidth: CGFloat = 25,
        action: ( () -> Void)? = nil
    ) {
        self.iconName = iconName
        self.iconColor = iconColor
        self.forParalax = forParalax
        self.circleWidth = circleWidth
        self.action = action
    }
    
    var body: some View {
        Button {
            if let action = action {
                action()
            }
        } label: {
            if forParalax {
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.6))
                        .frame(width: circleWidth, height: circleWidth)
                    
                    Image(systemName: iconName)
                        .font(.system(size: iconFontSize, weight: .bold))
                        .foregroundColor(getIconColor)
                }
            } else {
                Image(systemName: iconName)
                    .font(.system(size: circleWidth, weight: .semibold))
                    .foregroundColor(getIconColor)
            }
        }
        .disabled(action == nil)
    }
    
    private var getIconColor: Color {
        if forParalax {
            return iconColor ?? .white
        } else {
            return iconColor ?? .primary
        }
    }
}
