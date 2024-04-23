//
//  BackdropHeaderBuilder.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/19/24.
//

import SwiftUI

struct BackdropTabViewBuilder: View {
    
    let backdrops: [String]?
    let showGradient: Bool
    @State private var selectionImageIndex: Int = 0
    @State private var sliderIsAuto: Bool = true
    public let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    private let labelColor: Color = AppAssets.backgroundColor
    
    init(backdrops: [String]?, showGradient: Bool = true) {
        self.backdrops = backdrops
        self.showGradient = showGradient
    }
    
    init(image: String?, showGradient: Bool = true) {
        self.backdrops = image.map { [$0] }
        self.showGradient = showGradient
    }
    
    var body: some View {
        
        switch backdrops {
        case let .some(backdrops) where backdrops.count > 1:
            TabView(selection: $selectionImageIndex) {
                ForEach(0..<backdrops.count, id: \.self){ index in
                    let imageName = backdrops[index]
                    
                    CustomAsyncImage(
                        path: imageName,
                        placeholder: {
                            ImageType.backdrop.placeholder
                        },
                        image: {
                            Image(uiImage: $0)
                                .resizable()
                        }
                    )
                    .aspectRatio(contentMode: .fill)
                    .gradientOverlayModifier(color: labelColor)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onReceive(timer, perform: { _ in
                
                if sliderIsAuto {
                    withAnimation {
                        selectionImageIndex = selectionImageIndex < backdrops.count ? selectionImageIndex + 1 : 0
                    }
                }
            })
            .overlay(alignment: .bottomTrailing) {
                HStack {
                    Button(action: {
                        withAnimation {
                            sliderIsAuto.toggle()
                        }
                    }, label: {
                        Image(systemName: sliderIsAuto ? "pause.fill" : "play.fill")
                            .sliderCounterAndPlayModifier()
                    })
                    
                    Text("\(selectionImageIndex + 1) / \(backdrops.count)")
                        .sliderCounterAndPlayModifier()
                }
                .offset(x: -10)
            }
        
        case let .some(backdrops) where backdrops.count == 1:
            CustomAsyncImage(
                path: backdrops.first,
                placeholder: {
                    ImageType.backdrop.placeholder
                },
                image: {
                    Image(uiImage: $0)
                        .resizable()
                }
            )
            .aspectRatio(contentMode: .fill)
            .if(showGradient, transform: { image in
                image
                    .gradientOverlayModifier(color: labelColor)
            })
        
        default:
            AppAssets.DefaultImages.backdrop
                .resizable()
                .aspectRatio(contentMode: .fill)
                .gradientOverlayModifier(color: labelColor)
        }
    }
}
