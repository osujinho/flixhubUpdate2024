//
//  ScreenSize.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/11/24.
//

import SwiftUI

/**
 
    How to use
 
        @Environment(\.screenSize) var screenSize
 */

private struct ScreenSizeKey: EnvironmentKey {
    static var defaultValue: CGSize {
        guard let window = UIApplication.keyWindow else {
            return UIScreen.main.bounds.size
        }
//        let screenSize = CGSize(width: window.frame.width - (window.safeAreaInsets.left + window.safeAreaInsets.right),
//                                height: window.frame.height - (window.safeAreaInsets.top + window.safeAreaInsets.bottom))
        let screenSize = CGSize(width: window.frame.width, height: window.frame.height)
        return screenSize
    }
}

extension EnvironmentValues {
    var screenSize: CGSize {
        self[ScreenSizeKey.self]
    }
}
