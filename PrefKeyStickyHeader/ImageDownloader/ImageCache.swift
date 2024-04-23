//
//  ImageCache.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/6/24.
//

import SwiftUI

struct ImageCache: CashableImage {
    private var cache: NSCache<NSString, UIImage> = {
        ///  We are computing the cache so that we can customize it a bit before we return it
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100   /// Maximum number of objects the cache can hold
        
        /// Total Mb or Gb size the cache can hold before deleting items
        cache.totalCostLimit = 1024 * 1024 * 100   /// 100 mb
        return cache
    }()
    
    subscript(_ path: String) -> UIImage? {
        get { cache.object(forKey: path as NSString) }
        set { newValue == nil ? cache.removeObject(forKey: path as NSString) : cache.setObject(newValue!, forKey: path as NSString) }
    }
}
