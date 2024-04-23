//
//  ImageType.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/7/24.
//

import SwiftUI

enum ImageType {
    case poster, backdrop, profile, youtube, link, icon
    
    var defaultWidth: CGFloat {
        switch self {
        case .poster, .profile: return 100
        case .backdrop, .youtube: return 200
        case .link: return  0
        case .icon: return 80
        }
    }
    
    var detailCarouselWidth: CGFloat {
        switch self {
        case .poster, .profile: return 150
        case .backdrop, .youtube: return 250
        case .link: return  0
        case .icon: return 80
        }
    }
    
    var aspectRatio: CGFloat? {
        switch self {
        case .poster, .profile: return 2/3
        case .backdrop, .youtube: return 16/9
        case .icon: return 1/1
        case .link: return nil
        }
    }
    
    var placeholder: Image {
        switch self {
        case .poster, .link: AppAssets.DefaultImages.poster.resizable()
        case .backdrop: AppAssets.DefaultImages.backdrop.resizable()
        case .profile: AppAssets.DefaultImages.profile.resizable()
        case .youtube: AppAssets.DefaultImages.youtube.resizable()
        case .icon: AppAssets.DefaultImages.icon.resizable()
        }
    }
    
    static func getHeight(width: CGFloat? = nil, imageType: ImageType) -> CGFloat? {
        
        let width = width ?? imageType.defaultWidth
        switch imageType {
        case .poster, .profile: return width * 1.5
        case .backdrop, .youtube: return (9 * width) / 16
        case .link: return nil
        case .icon: return width
        }
    }
}
