//
//  NavBarData.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/18/24.
//

import SwiftUI

struct NavBarData {
    let title: String
    let hasBackButton: Bool
    let trailingIcon: String?
    let trailingAction: (() -> ())?
    let trailingIconColor: Color?
    
    init(title: String, hasBackButton: Bool, trailingIcon: String? = nil, trailingAction: ( () -> Void)? = nil, trailingIconColor: Color? = nil) {
        self.title = title
        self.hasBackButton = hasBackButton
        self.trailingIcon = trailingIcon
        self.trailingAction = trailingAction
        self.trailingIconColor = trailingIconColor
    }
}
