//
//  StringWidth.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 11/30/23.
//

import SwiftUI

/// To Get the width of a String based on the font
extension String {
   func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

/*
    Use as follows
 let width = "SomeString".widthOfString(usingFont: UIFont.systemFont(ofSize: 17, weight: .bold))
 */
