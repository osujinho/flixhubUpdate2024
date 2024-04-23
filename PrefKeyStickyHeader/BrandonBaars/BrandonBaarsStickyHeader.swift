//
//  BrandonBaarsStickyHeader.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 11/28/23.
//

import SwiftUI

struct BrandonBaarsStickyHeader: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var titleRect: CGRect = .zero
    @State private var backdropRect: CGRect = .zero
    
    private let articleTitle: String = "How to build a parallax scroll view"
    private let scrollOffsetMin: CGFloat = 50
    private var collapsedImageHeight: CGFloat {
        return safeAreaInsets.top + 30
    }
    
    // MARK: - For the content VStack
    private let topPaddingValue: CGFloat = 16
    
    var body: some View {
        GeometryReader { proxy in
            
            let size = proxy.size
            let imageHeight = size.height * 0.3
            
            ZStack {
                AppAssets.backgroundColor.ignoresSafeArea(.all)
                
                ScrollView {
                    GeometryReader { geometry in
                        
                        ZStack(alignment: .bottom) {
                            Image("backdrop")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: getHeightForHeaderImage(geometry))
                                .blur(radius: getBlurRadiusForImage(geometry))
                                .clipped()
                                .background(GeometryGetter(rect: self.$backdropRect))
                            
                            // Shows after the scrolling up to a certain point.
                            Text(articleTitle)
                                .font(.avenirNext(size: 17))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .offset(x: 0, y: getHeaderTitleOffset())
                        }
                        .clipped()
                        .offset(y: getOffsetForHeaderImage(geometry, imageHeight: imageHeight))
                    }
                    .frame(height: imageHeight)
                    .zIndex(1)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image("poster")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 55, height: 55)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                            
                            VStack(alignment: .leading) {
                                Text("Article Written By")
                                    .font(.avenirNext(size: 12))
                                    .foregroundColor(.gray)
                                Text("Brandon Baars")
                                    .font(.avenirNext(size: 17))
                            }
                        }
                        
                        Text("02 January 2019 • 5 min read")
                            .font(.avenirNextRegular(size: 12))
                            .foregroundColor(.gray)
                        
                        Text(articleTitle)
                            .font(.avenirNext(size: 28))
                            .background(GeometryGetter(rect: self.$titleRect))
                        
                        Text(loremIpsum)
                            .lineLimit(nil)
                            .font(.avenirNextRegular(size: 17))
                    }
                    .padding(.horizontal)
                    .padding(.top, topPaddingValue)
                    .zIndex(0)
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    private func getScrollOffset(_ geometry: GeometryProxy, forMinY: Bool = true) -> CGFloat {
        forMinY ? geometry.frame(in: .global).minY : geometry.frame(in: .global).maxY
    }
    
    private func navBarScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        //return -offset >= 0 ? -offset : 0
        return offset
    }
    
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy, imageHeight: CGFloat) -> CGFloat {
        
        let offset = getScrollOffset(geometry)
        let sizeOffScreen = imageHeight - collapsedImageHeight
        
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
    
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        
        if offset > 0 {
            return imageHeight + offset
        }
        
        return imageHeight
    }
    
    // at 0 offset our blur will be 0
    // at 300 offset our blur will be 6
    private func getBlurRadiusForImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry, forMinY: false)
        let height = geometry.size.height
        let blur = (height - max(offset, 0)) / height // (values will range from 0 - 1)
        return blur * 6 // Values will range from 0 - 6
    }
    
    private func getHeaderTitleOffset() -> CGFloat {
        let currentYPos = titleRect.midY
        // (x - min) / (max - min) -> Normalize our values between 0 and 1
        
        // If our Title has surpassed the bottom of our image at the top
        // Current Y POS will start at 75 in the beggining. We essentially only want to offset our 'Title' about 30px.
        if currentYPos < backdropRect.maxY {
            let maxYValue: CGFloat = collapsedImageHeight // What we start at for our scroll offset (75)
            let currentYValue = currentYPos
            
            let percentage = max(-1, (currentYValue - maxYValue) / (maxYValue - scrollOffsetMin)) // Normalize our values from 75 - 50 to be between 0 to -1, If scrolled past that, just default to -1
            let finalOffset: CGFloat = -30.0 // We want our final offset to be -30 from the bottom of the image header view
            // We will start at 20 pixels from the bottom (under our sticky header)
            // At the beginning, our percentage will be 0, with this resulting in 20 - (x * -30)
            // as x increases, our offset will go from 20 to 0 to -30, thus translating our title from 20px to -30px.
            
            return 20 - (percentage * finalOffset)
        }
        
        return .infinity
    }
}

#Preview {
    //ContentView()
    BrandonBaarsStickyHeader()
}
