//
//  ParalaxManager.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/19/24.
//

import SwiftUI

enum ParalaxManager {
    
    // MARK: - For Headers
    static func posterScaleEffect(scrollOffset: CGFloat, sizeOffScreen: CGFloat) -> CGFloat {
        let progress = scrollOffset / -sizeOffScreen
        
        let scale = 1.8 - (progress < 1.0 ? progress : 1)
        
        // since we are scaling the view to 0.8
        // 1.8 - 1 will be 0.8
        
        return scale < 1 ? scale : 1
    }
    
    static func posterOffset(imageHeight: CGFloat?, scrollOffset: CGFloat, sizeOffScreen: CGFloat) -> CGFloat {
        
        guard let imageHeight = imageHeight else { return 0 }
        
        let posterTopOffset = imageHeight * 0.25
        
        let progress = (scrollOffset / -sizeOffScreen) * posterTopOffset
        
        let startingOffset = progress <= posterTopOffset ? progress : posterTopOffset
        
        if scrollOffset < 0 {
            return startingOffset - posterTopOffset
        }
        return -posterTopOffset
    }
    
    // MARK: - For Detail View Paralax effect
    
    static func getScrollOffset(_ geometry: GeometryProxy, forMinY: Bool = true) -> CGFloat {
        forMinY ? geometry.frame(in: .global).minY : geometry.frame(in: .global).maxY
    }
    
    static func getOffsetForHeaderImage(_ geometry: GeometryProxy, collapsedNavBarHeight: CGFloat, backdropHeight: CGFloat) -> CGFloat {
        
        let offset = ParalaxManager.getScrollOffset(geometry)
        let sizeOffScreen = backdropHeight - collapsedNavBarHeight
        
        // if our offset is roughly less than -225 (the amount scrolled / amount off screen)
        if offset < -sizeOffScreen {
            // Since we want 75 px fixed on the screen we get our offset of -225 or anything less than. Take the abs value of
            let imageOffset = abs(min(-sizeOffScreen, offset))
            
            // Now we can the amount of offset above our size off screen.
            // So if we've scrolled -250px our size offscreen is -225px we offset our image by an additional 25 px to put it back at the amount needed to remain offscreen/amount on screen.
            return imageOffset - sizeOffScreen
        }
        
        // Image was pulled down
        if offset > 0 {
            return -offset
        }
        
        return 0
    }
    
    static func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = ParalaxManager.getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        
        if offset > 0 {
            return imageHeight + offset
        }
        
        return imageHeight
    }
    
    static func getPickerOffset(_ geometry: GeometryProxy, collapsedNavBarHeight: CGFloat) -> CGFloat {
        let stickyHeight = collapsedNavBarHeight
        let pickerOffset = ParalaxManager.getScrollOffset(geometry)
        
        return pickerOffset < stickyHeight ? -pickerOffset + stickyHeight : 0
    }
    
    static func showDivider(_ geometry: GeometryProxy, collapsedNavBarHeight: CGFloat) -> Bool {
        let pickerOffset = ParalaxManager.getScrollOffset(geometry)
        return pickerOffset < collapsedNavBarHeight
    }
    
    static func containerZindex(backdropHeight: CGFloat, collapsedNavBarHeight: CGFloat, scrollOffset: CGFloat) -> Double {
        let sizeOffScreen = backdropHeight - collapsedNavBarHeight
        return scrollOffset < -sizeOffScreen ? 0 : 1
    }
}
