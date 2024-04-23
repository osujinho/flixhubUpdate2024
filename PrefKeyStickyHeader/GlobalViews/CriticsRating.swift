//
//  CriticsRating.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/16/24.
//

import SwiftUI

struct CriticsRatingView: View {
    
    let ratings: [CriticRatingResponse]?
    private let notRated: String = "NR"
    private let noRatingColor: Color = Color.gray
    
    var body: some View {
        
        Grid(alignment: .topLeading,
                     horizontalSpacing: 20,
             verticalSpacing: 5) {
            
            GridRow {
                Text("IMDb")
                    .font(.system(size: 13, weight: .bold))
                    .padding(.vertical, 2)
                    .padding(.horizontal, 4)
                    .background(Color.yellow)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                getRatingView(critic: .imdb)
            }
            
            GridRow {
                Text("🍅")
                    .font(.system(size: 18))
                
                getRatingView(critic: .rottenTomatoes)
            }
            
            GridRow {
                Image("meta")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                
                getRatingView(critic: .metacritic)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func getRating(critic: CriticsRating) -> String {
        guard let ratings = ratings, !ratings.isEmpty else { return notRated }

        switch critic {
        case .imdb:
            for rating in ratings {
                if rating.source == CriticsRating.imdb.description {
                    if let valueString = rating.value?.components(separatedBy: "/").first {
                        return valueString
                    }
                    return notRated
                }
            }
            return notRated
            
        case .rottenTomatoes:
            for rating in ratings {
                if let rottenRating = rating.value, rating.source == CriticsRating.rottenTomatoes.description {
                    return rottenRating
                }
            }
            return notRated
            
        case .metacritic:
            for rating in ratings {
                if rating.source == CriticsRating.metacritic.description {
                    if let valueString = rating.value?.components(separatedBy: "/").first {
                        return valueString
                    }
                    return notRated
                }
            }
            return notRated
        }
    }
    
    private func backgroundColor(value: String?) -> Color {
        
        guard let value = value, value != notRated else { return noRatingColor }

        // Define a regular expression pattern to match any digits
        let digitPattern = #"\d+"#

        // Create a regular expression object with the defined pattern
        guard let regex = try? NSRegularExpression(pattern: digitPattern) else {
            return noRatingColor
        }

        // Check if the string contains any digits
        let hasDigits = regex.firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.utf16.count)) != nil

        if hasDigits {
            // If the string contains digits, remove any non-numeric characters
            let numericString = value.filter { "0123456789".contains($0) }
            return getColor(value: Int(numericString))
        } else {
            // If the string does not contain digits, return nil
            return noRatingColor
        }

        func getColor(value: Int?) -> Color {
            if let value = value {
                switch value {
                case _ where value <= 49: return Color.red
                case _ where value >= 50 && value <= 64: return Color.orange
                case _ where value >= 65 && value <= 79: return Color.yellow
                default: return Color.green
                }
            } else {
                return noRatingColor
            }
        }
    }
    
    @ViewBuilder
    private func getRatingView(critic: CriticsRating) -> some View {
        
        let value = getRating(critic: critic)
        let color = backgroundColor(value: value)
        
        Text(value)
            .font(.system(size: 13))
            .padding(.vertical, 2)
            .padding(.horizontal, 4)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
    
    enum CriticsRating: Identifiable, CustomStringConvertible {
        case imdb
        case rottenTomatoes
        case metacritic

        var id: CriticsRating { self }

        var description: String {
            switch self {
            case .imdb: return "Internet Movie Database"
            case .rottenTomatoes: return "Rotten Tomatoes"
            case .metacritic: return "Metacritic"
            }
        }
    }
}
