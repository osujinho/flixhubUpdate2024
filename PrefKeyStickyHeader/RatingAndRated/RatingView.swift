//
//  RatingView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 11/30/23.
//

import SwiftUI

struct RatingView: View {
    
    let rating: Double?
    let frameSize: CGFloat
    private let noRating: String = "NR"
    
    var fontSize: CGFloat {
        frameSize * 0.37
    }
    
    var formattedRating: String { RatingManager.formatRating(forRating: rating, withPercent: false) }
    var ratingColor: Color { RatingManager.colorType(forRating: rating).bgColor }
    var ratingPercent: CGFloat { CGFloat(RatingManager.convertToTens(forRating: rating)) }
    
    init(rating: Double?, frameSize: CGFloat) {
        self.rating = rating
        self.frameSize = max(frameSize, 28)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    ratingColor.opacity(0.5),
                    lineWidth: 3
                )
            Circle()
                .trim(from: 0.0, to: ratingPercent/100)
                .stroke(
                    ratingColor,
                    style: StrokeStyle(
                        lineWidth: 3,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
        }
        .frame(width: frameSize, height: frameSize)
        .padding(3)
        .background(AppAssets.posterLabelColor)
        .clipShape(Circle())
        .overlay(
            HStack(spacing: 0){
                Text(formattedRating)
                    .font(.system(size: fontSize, weight: .semibold))
                if formattedRating != noRating {
                    Text("\u{FE6A}")
                        .font(.system(size: fontSize * 0.9, weight: .semibold))
                        .baselineOffset(7)
                }
            }
            .foregroundColor(.white)
            .padding(2)
        )
    }
}

#Preview {
    RatingView(rating: 8.9, frameSize: 20)
}
