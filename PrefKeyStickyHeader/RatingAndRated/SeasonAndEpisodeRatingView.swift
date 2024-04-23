//
//  SeasonAndEpisodeRatingView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/14/24.
//

import SwiftUI

struct SeasonAndEpisodeRatingView: View {
    
    let rating: Double?
    var formattedRating: String { RatingManager.formatRating(forRating: rating) }
    var ratingColor: RatingManager { RatingManager.colorType(forRating: rating) }
    
    private let cornerRadius: CGFloat = 5
    private let width: CGFloat = 35
    private let height: CGFloat = 18
    private var ratingPercent: Int { RatingManager.convertToTens(forRating: rating) }
    
    init(rating: Double?) {
        self.rating = rating
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(RatingManager.noRating.bgColor)
                .frame(width: width, height: height)
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(ratingColor.bgColor)
                .frame(width: colorWidth, height: height)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(
            Text(formattedRating)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(Color.black.opacity(0.8))
        )
        .padding(1)
        .background(AppAssets.posterColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    private var colorWidth: CGFloat {
        let percentWidth: CGFloat = CGFloat(ratingPercent) / 100 * width
        return min(percentWidth, width)
    }
}

#Preview {
    ZStack {
        AppAssets.backgroundColor
        
        SeasonAndEpisodeRatingView(rating: 1.462)
    }
}
