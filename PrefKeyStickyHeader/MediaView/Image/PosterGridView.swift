//
//  PosterGridView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/9/24.
//

import SwiftUI

struct PosterGridView<Media: MediaCollection>: View {
    
    let media: Media
    
    @Environment(\.colorScheme) var scheme
    #warning("Change to alternate after favorite implementation")
    @State private var isFavorite: Bool = false
    private let posterWidth: CGFloat = GlobalValues.gridPosterWidth
    private let bgColor: Color = AppAssets.backgroundColor
    private var ratingHeight: CGFloat { posterWidth * 0.22 }
    private var favoriteIcon: String {
        isFavorite ? "suit.heart.fill" : "suit.heart"
    }
    private var posterHeight: CGFloat { posterWidth * 1.5 }
    private var iconColor: Color { isFavorite ? .red : .gray }
    
    var body: some View {
        VStack(spacing: 0) {
            
            CustomAsyncImage(
                path: media.poster,
                placeholder: { ImageType.poster.placeholder },
                image: {
                    Image(uiImage: $0)
                        .resizable()
                })
                .aspectRatio(contentMode: .fill)
                .frame(width: posterWidth, height: posterHeight)
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
            
            VStack(alignment: .leading, spacing: 1) {
                if let rating = media.rating {
                    RatingView(rating: rating, frameSize: ratingHeight)
                        .padding(.top, -ratingHeight * 0.8)
                }
                
                Text(media.name?.capitalized.removeExtraSpaces ?? GlobalValues.defaultWrappedString)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                    .padding(.bottom, 2)
                    .padding(.top, labelTopPadding)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let date = (media as? MovieCollection)?.releaseDate ?? (media as? SeriesCollection)?.firstAirDate {
                    Text(GlobalMethods.formatDate(date, fullDate: true))
                        .foregroundColor(.secondary)
                }
                
                if let role = (media as? (any MovieAndSeriesCreditCollection))?.role {
                    Text(role.removeExtraSpaces)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
            }
            .font(.system(size: fontSize))
            .padding(.horizontal, 5)
            .frame(width: posterWidth, height: labelHeight, alignment: .topLeading)
            .background(bgColor)
        }
        .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
        .shadow(color: Color.primary.opacity(0.4), radius: 5, x: 0, y: 2 )
        .shadow(color: bgColor.opacity(0.3), radius: 20, x: 0, y: 10 )
    }
    
    var labelHeight: CGFloat {
        switch media {
        case is PersonCollection: return posterHeight * 0.3
        
        case is any MovieAndSeriesCreditCollection: return posterHeight * 0.43
        
        default: return posterHeight * 0.43
        }
    }
    
    var labelTopPadding: CGFloat {
        switch media {
        case is PersonCollection, is any MovieAndSeriesCreditCollection:
            return 2
        default:
            return 0
        }
    }
    
    var fontSize: CGFloat {
        switch media {
        case is PersonCollection, is any MovieAndSeriesCreditCollection:
            return 13
        default:
            return 10
        }
    }
}

#Preview {
    ZStack {
        AppAssets.backgroundColor
        
        PosterGridView(media: hunger)
    }
}
