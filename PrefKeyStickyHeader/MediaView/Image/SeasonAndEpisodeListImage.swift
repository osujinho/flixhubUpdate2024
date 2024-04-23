//
//  BackdropListView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/14/24.
//

import SwiftUI

struct SeasonAndEpisodeListImage: View {
    
    let imagePath: String?
    let rating: Double?
    let isPoster: Bool
    let imageWidth: CGFloat?
    var imageWidthToUse: CGFloat {
        imageWidth ?? (isPoster ? 80 : 115)
    }
    var imageType: ImageType {
        isPoster ? .poster : .backdrop
    }
    
    private let bgColor: Color = AppAssets.backgroundColor
    private var backdropHeight: CGFloat? { ImageType.getHeight(width: imageWidthToUse, imageType: imageType) }
    private var ratingHeight: CGFloat { imageWidthToUse * 0.23 }

    init(imagePath: String?, rating: Double? = nil, isPoster: Bool, imageWidth: CGFloat? = nil) {
        self.imagePath = imagePath
        self.rating = rating
        self.isPoster = isPoster
        self.imageWidth = imageWidth
    }
    
    var body: some View {
        CustomAsyncImage(
            path: imagePath,
            placeholder: {
                imageType.placeholder
            },
            image: {
                Image(uiImage: $0)
                    .resizable()
            }
        )
        .aspectRatio(contentMode: .fill)
        .frame(width: imageWidthToUse, height: backdropHeight)
        .clipShape(RoundedRectangle(cornerRadius: 5.0))
        .overlay(alignment: .topTrailing) {
            if let rating = rating {
                SeasonAndEpisodeRatingView(rating: rating)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
        .shadow(color: Color.primary.opacity(0.4), radius: 5, x: 0, y: 2 )
        .shadow(color: bgColor.opacity(0.3), radius: 20, x: 0, y: 10 )
    }
}

#Preview {
    ZStack {
        AppAssets.backgroundColor
        
        SeasonAndEpisodeListImage(imagePath: "/lXBIhFheyDRA72vRQvYF1mkEF27.jpg", rating: 7.856, isPoster: false)
    }
}
