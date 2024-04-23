//
//  RatingManager.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/15/24.
//

import SwiftUI

enum RatingManager {
    case red, orange, yellow, chartreuse, lightGreen, darkGreen, noRating
    
    var bgColor: Color {
        switch self {
        case .red: return Color(red: 150 / 255.0, green: 0 / 255.0, blue: 0 / 255.0)
        case .orange: return Color.orange
        case .yellow: return Color.yellow
        case .chartreuse: return Color(red: 224 / 255.0, green: 227 / 255.0, blue: 14 / 255.0)
        case .lightGreen: return Color(red: 187 / 255.0, green: 235 / 255.0, blue: 138 / 255.0)
            //Color(red: 144 / 255.0, green: 238 / 255.0, blue: 145 / 255.0)
        case .darkGreen: return Color(red: 35 / 255.0, green: 211 / 255.0, blue: 123 / 255.0)
        case .noRating: return Color.gray
        }
    }
    
    var fontColor: Color {
        switch self {
        case .yellow, .lightGreen, .chartreuse, .orange: return Color.black
        default: return Color.white
        }
    }
    
    static func colorType(forRating rating: Double?) -> RatingManager {
        
        let convertedRating = convertToTens(forRating: rating)
        
        switch convertedRating {
        case 0: return .noRating
        case 1..<30: return .red
        case 30..<45: return .orange
        case 45..<60: return .yellow
        case 60..<75: return .chartreuse
        case 75..<85: return .lightGreen
        default: return .darkGreen
        }
    }
    
    static func formatRating(forRating rating: Double?, withPercent: Bool = true) -> String {
        
        let noRating: String = "NR"
        let convertedRating = convertToTens(forRating: rating)
        if convertedRating > 0 {
            if withPercent {
                return "\(convertedRating)\u{FE6A}"
            } else {
                return "\(convertedRating)"
            }
        }
        return noRating
    }
    
    static func convertToTens(forRating rating: Double?) -> Int {
        guard let rating = rating else { return 0 }
        let tensRating = Int(ceil(rating * 10))
        return min(tensRating, 100)
    }
}

#Preview {
    ZStack {
        AppAssets.backgroundColor
        
        VStack {
            SeasonAndEpisodeRatingView(rating: 8.462)
            
            RatingView(rating: 8.9, frameSize: 25)
        }
    }
}
