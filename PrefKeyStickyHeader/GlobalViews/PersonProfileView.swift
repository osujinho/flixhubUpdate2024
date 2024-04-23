//
//  PersonProfileView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/20/24.
//

import SwiftUI

struct PersonProfileView: View {
    
    let name: String
    let poster: String?
    let role: String?
    let rating: Double?
    let forCarousel: Bool
    
    private var imageWidth: CGFloat {
        forCarousel ? ImageType.poster.defaultWidth : 115
    }
    
    init(name: String, poster: String?, role: String?, rating: Double?, forCarousel: Bool = false) {
        self.name = name
        self.poster = poster
        self.role = role
        self.rating = rating
        self.forCarousel = forCarousel
    }
    
    var body: some View {
        if forCarousel {
            VStack(spacing: 10) {
                PosterListView(
                    posterPath: poster,
                    rating: forCarousel ? nil : rating,
                    posterWidth: imageWidth
                )
                
                NameAndRole()
            }
        } else {
            HStack(spacing: 20) {
                PosterListView(
                    posterPath: poster,
                    rating: forCarousel ? nil : rating,
                    posterWidth: imageWidth
                )
                
                NameAndRole()
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func NameAndRole() -> some View {
        VStack(alignment: forCarousel ? .center : .leading, spacing: 5) {
            // Name
            Text(name)
                .font(.system(size: nameFontSize, weight: .semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(forCarousel ? .center : .leading)
                .fixedSize(horizontal: false, vertical: forCarousel ? true : false)
            
            // Movie Role
            OptionalMethods.validOptionalBuilder(value: role) { role in
                
                Text(role)
                    .font(.system(size: (nameFontSize * 0.94)))
                    .foregroundColor(.secondary)
                    .italic()
                    .multilineTextAlignment(forCarousel ? .center : .leading)
                    .fixedSize(horizontal: false, vertical: forCarousel ? true : false)
            }
        }
        .frame(width: maxWidth)
    }
    
    private var maxWidth: CGFloat? {
        forCarousel ? (imageWidth * 1.2) : nil
    }
    
    private var nameFontSize: CGFloat {
        forCarousel ? 13 : 15
    }
}

#Preview {
    ZStack {
        AppAssets.backgroundColor
        
        PersonProfileView(name: "Mahershalalhashbaz Cumberbatch", poster: gal.poster, role: "Stephen Strange / Doctor Strange", rating: 8.4, forCarousel: true)
    }
}
