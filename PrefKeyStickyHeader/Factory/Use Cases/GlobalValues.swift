//
//  GlobalValues.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/22/24.
//

import SwiftUI

enum GlobalValues {
    
    static let defaultWrappedString: String = "Not Available"
    static let unwantedStrings: Set<String> = ["Not Specified", "", " ", defaultWrappedString]
    
    // MARK: - For Trailer and Rating Container
    static let ratingFrameSize: CGFloat = 35
    
    // MARK: - For GridPosterView
    static let gridPosterWidth: CGFloat = 115
    
    // MARK: - For PickerViews
    static let pickerItemButtonHeight: CGFloat = 40
}
