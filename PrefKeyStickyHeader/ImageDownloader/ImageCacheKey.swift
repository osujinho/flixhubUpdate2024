//
//  ImageCacheKey.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/7/24.
//

import SwiftUI

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: CashableImage = ImageCache()
}

extension EnvironmentValues {
    var imageCache: CashableImage {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
