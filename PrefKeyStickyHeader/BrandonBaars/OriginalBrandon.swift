//
//  OriginalBrandon.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 12/22/23.
//

import SwiftUI

struct OriginalBrandon: View {
    
    private let imageHeight: CGFloat = 300
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    //private let collapsedImageHeight: CGFloat = 75
    
    // MARK: - Track title Offset
    
    var collapsedImageHeight: CGFloat {
        safeAreaInsets.top + 40
    }
    var navBarTitleMinY: CGFloat {
        safeAreaInsets.top
    }
    
    private let articleTitle: String = "How to build a parallax scroll view"
    
    @State private var titleRect: CGRect = .zero
    @State private var backdropRect: CGRect = .zero
    @State private var navBarTitleRect: CGRect = .zero
    
    @State var titleInNavOffset: CGFloat = 0
    @State var titleInBodyOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            
            AppAssets.backgroundColor.ignoresSafeArea(edges: .all)
            
            ScrollView {
                
                GeometryReader { geometry in
                    // 3
                    ZStack(alignment: .bottom) {
                        Image("backdrop")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                            .blur(radius: self.getBlurRadiusForImage(geometry))
                            .clipped()
                            .background(GeometryGetter(rect: self.$backdropRect))
                        
                        // 4
                        Text(articleTitle)
                            .font(.avenirNext(size: 15))
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .offset(x: 0, y: self.getHeaderTitleOffset())
                            .background(GeometryGetter(rect: self.$navBarTitleRect))
                    }
                    .clipped()
                    .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
                }
                .frame(height: imageHeight)
                .zIndex(1.0)
                
                VStack {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image("poster")
                                .resizable()
                                .scaledToFill()
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
                            .background(GeometryGetter(rect: self.$titleRect)) // 2
                        
                        VStack {
                            VStack(alignment: .leading, spacing: 5) {
                                TextWithLabelView(label: "Top", content: safeAreaInsets.top)
                                TextWithLabelView(label: "TitleMidY", content: titleRect.midY)
                                TextWithLabelView(label: "HeaderRectMax", content: backdropRect.maxY)
                                TextWithLabelView(label: "NavTitleOffset", content: getHeaderTitleOffset())
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(loremIpsum)
                                .lineLimit(nil)
                                .font(.avenirNextRegular(size: 17))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16.0)
                }
            }.edgesIgnoringSafeArea(.all)
        }
    }
    
    // MARK: - Helper Functions
    
    func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let sizeOffScreen = imageHeight - collapsedImageHeight
        
        // if our offset is roughly less than -225 (the amount scrolled / amount off screen)
        if offset < -sizeOffScreen {
            // Since we want 75 px fixed on the screen we get our offset of -225 or anything less than. Take the abs value of
            let imageOffset = abs(min(-sizeOffScreen, offset))
            
            // Now we can the amount of offset above our size off screen. So if we've scrolled -250px our size offscreen is -225px we offset our image by an additional 25 px to put it back at the amount needed to remain offscreen/amount on screen.
            return imageOffset - sizeOffScreen
        }
        
        // Image was pulled down
        if offset > 0 {
            return -offset
            
        }
        
        return 0
    }
    
    func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        
        if offset > 0 {
            return imageHeight + offset
        }
        
        return imageHeight
    }
    
    // at 0 offset our blur will be 0
    // at 300 offset our blur will be 6
    func getBlurRadiusForImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).maxY
        
        let height = geometry.size.height
        let blur = (height - max(offset, 0)) / height // (values will range from 0 - 1)
        
        return blur * 6 // Values will range from 0 - 6
    }
    
    // 1
//    private func getHeaderTitleOffset() -> CGFloat {
//        let currentYPos = titleRect.midY
//        
//        // (x - min) / (max - min) -> Normalize our values between 0 and 1
//        
//        // If our Title has surpassed the bottom of our image at the top
//        // Current Y POS will start at 75 in the beggining. We essentially only want to offset our 'Title' about 30px.
//        
//        if currentYPos < backdropRect.maxY {
//            let minYValue: CGFloat = 50.0 // What we consider our min for our scroll offset
//            let maxYValue: CGFloat = collapsedImageHeight // What we start at for our scroll offset (75)
//            let currentYValue = currentYPos
//            
//            let percentage = max(-1, (currentYValue - maxYValue) / (maxYValue - minYValue)) // Normalize our values from 75 - 50 to be between 0 to -1, If scrolled past that, just default to -1
//            let finalOffset: CGFloat = -30.0 // We want our final offset to be -30 from the bottom of the image header view
//            
//            // We will start at 20 pixels from the bottom (under our sticky header)
//            // At the beginning, our percentage will be 0, with this resulting in 20 - (x * -30)
//            // as x increases, our offset will go from 20 to 0 to -30, thus translating our title from 20px to -30px.
//            
//            return 20 - (percentage * finalOffset)
//        }
//        
//        return .infinity
//    }
    
    private func getHeaderTitleOffset() -> CGFloat {
        let currentYPos = titleRect.midY
        
        // (x - min) / (max - min) -> Normalize our values between 0 and 1
        
        // If our Title has surpassed the bottom of our image at the top
        // Current Y POS will start at 75 in the beggining. We essentially only want to offset our 'Title' about 30px.
        
        if currentYPos < backdropRect.maxY {
            let minYValue: CGFloat = navBarTitleMinY // What we consider our min for our scroll offset
            let maxYValue: CGFloat = collapsedImageHeight // What we start at for our scroll offset (75)
            
            // We will start at 20 pixels from the bottom (under our sticky header)
            // So it will be 10 at the beginning and -10 when set.
            let offsetFromOrigin: CGFloat = 10
            
            let currentYValue = currentYPos
            
            let percentage = max(-1, (currentYValue - maxYValue) / (maxYValue - minYValue)) // Normalize our values from 75 - 50 to be between 0 to -1, If scrolled past that, just default to -1
            //let finalOffset: CGFloat = -(maxYValue - minYValue) // We want our final offset to be -30 from the bottom of the image header view
            let finalOffset: CGFloat = -((minYValue + offsetFromOrigin) / 2)
            let initialOffset: CGFloat = ((minYValue - offsetFromOrigin) / 2)
            // We will start at 20 pixels from the bottom (under our sticky header)
            // At the beginning, our percentage will be 0, with this resulting in 20 - (x * -30)
            // as x increases, our offset will go from 20 to 0 to -30, thus translating our title from 20px to -30px.
            
            return initialOffset - (percentage * finalOffset)
        }
        
        return .infinity
    }
}

#Preview {
    OriginalBrandon()
        .preferredColorScheme(.dark)
}

class ViewFrame: ObservableObject {
    var startingRect: CGRect?
    
    @Published var frame: CGRect {
        willSet {
            if startingRect == nil {
                startingRect = newValue
            }
        }
    }
    
    init() {
        self.frame = .zero
    }
}

struct TextWithLabelView: View {
    
    var label: String
    var content: CGFloat
    
    var body: some View {
        HStack(spacing: 10) {
            Text(label)
            
            Text("\(content)")
                .padding(5.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(lineWidth: 2.0)
                )
        }
    }
}
