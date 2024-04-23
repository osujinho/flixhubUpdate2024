//
//  PopoverContentData.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/18/24.
//

import SwiftUI

enum PopoverContent<Selection: Pickable> {
    case single(binding: Binding<Selection?>)
    case multiple(binding: Binding<Set<Selection>?>)
}
