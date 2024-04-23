//
//  CarouselItemView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/18/24.
//

import SwiftUI

struct CarouselItemView: View {
    
    let image: String?
    var imageType: ImageType
    
    var body: some View {
        CustomAsyncImage(
            path: image,
            placeholder: {
                imageType.placeholder
            },
            image: {
                Image(uiImage: $0)
                    .resizable()
            }
        )
        .aspectRatio(contentMode: .fill)
        .frame(
            width: imageType.detailCarouselWidth,
            height: ImageType.getHeight(width: imageType.detailCarouselWidth, imageType: imageType))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
