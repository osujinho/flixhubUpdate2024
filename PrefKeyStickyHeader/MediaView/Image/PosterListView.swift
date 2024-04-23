//
//  PosterListView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/20/24.
//

import SwiftUI

struct PosterListView: View {
    
    let posterPath: String?
    let rating: Double?
    let posterWidth: CGFloat
    
    #warning("Change to alternate after favorite implementation")
    @State private var isFavorite: Bool = false
    private let bgColor: Color = AppAssets.backgroundColor
    private var favoriteIcon: String {
        isFavorite ? "suit.heart.fill" : "suit.heart"
    }
    private var posterHeight: CGFloat? { ImageType.getHeight(width: posterWidth, imageType: .poster) }
    private var ratingHeight: CGFloat { posterWidth * 0.23 }
    private var iconColor: Color { isFavorite ? .red : .gray }
    
    init(posterPath: String?, rating: Double? = nil, posterWidth: CGFloat = 113) {
        self.posterPath = posterPath
        self.rating = rating
        self.posterWidth = posterWidth
    }
    
    var body: some View {
        CustomAsyncImage(
            path: posterPath,
            placeholder: {
                ImageType.poster.placeholder
            },
            image: {
                Image(uiImage: $0)
                    .resizable()
            }
        )
        .aspectRatio(contentMode: .fill)
        .frame(width: posterWidth, height: posterHeight)
        .clipShape(RoundedRectangle(cornerRadius: 5.0))
        .overlay(alignment: .topTrailing) {
            NavIconButton(
                iconName: favoriteIcon,
                iconColor: iconColor,
                circleWidth: ratingHeight * 0.8,
                action: {
                    withAnimation(.easeInOut) {
                        isFavorite.toggle()
                    }
                }
            )
        }
        .overlay(alignment: .bottomTrailing) {
            if let rating = rating {
                RatingView(rating: rating, frameSize: ratingHeight)
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
        
        PosterListView(posterPath: margot.poster, rating: 7.6)
    }
}
