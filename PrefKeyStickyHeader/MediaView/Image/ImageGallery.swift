//
//  ImageGallery.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/26/24.
//

import SwiftUI

struct ImageGallery: View {
    
    @EnvironmentObject var fullImageViewModel: FullImageViewModel
    var images: [String?]
    let imageType: ImageType
    
    private let navBarData: NavBarData  = .init(
        title: "",
        hasBackButton: true
    )
    
    var body: some View {
        ScrollScreenBuilder(navBarData: navBarData) {
            LazyVGrid(columns: AppAssets.gridColumns, alignment: .center, spacing: 10) {
                ForEach(images, id: \.self) { image in
                    CustomAsyncImage(
                        path: image,
                        placeholder: { imageType.placeholder },
                        image: {
                            Image(uiImage: $0)
                                .resizable()
                        }
                    )
                    .aspectRatio(imageType.aspectRatio, contentMode: .fill)
                    .onTapGestureModifier {
                        fullImageViewModel.displaySlideView(images, image: image, imageType: .poster)
                    }
                }
            }
            .transition(.move(edge: .bottom))
        }
        .showImageViewModifier
    }
}
