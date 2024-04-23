//
//  GenreView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/11/24.
//

import SwiftUI

struct GenreView: View {
    
    @State private var totalHeight: CGFloat = 100
    let genres: [GenreResponse]?
    private let fontColor: Color = .secondary
    private let spacing: CGFloat = 10
    private let horizontalPadding: CGFloat = 6
    
    var body: some View {
        
        VerticalLabelContainerBuilder(header: "Genre") {
            
            GeometryReader { proxy in
                Group {
                    OptionalMethods.conditionalOptionalBuilder(genres) { genres in
                        if useScrollView(geometry: proxy) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(genres, id: \.self) { genre in
                                        GenreIcon(genre: genre)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            }
                        } else {
                            HStack {
                                ForEach(genres, id: \.self) { genre in
                                    GenreIcon(genre: genre)
                                }
                            }
                        }
                    } else: {
                        Text(GlobalValues.defaultWrappedString)
                    }
                }
                .geometryHeightReader(height: $totalHeight)
            }
            .frame(height: totalHeight)
        }
    }
    
    private func useScrollView(geometry: GeometryProxy) -> Bool {
        guard let genres = genres else { return false }
        let totalStringWidth: CGFloat = genres.compactMap { $0.name?.widthOfString(usingFont: UIFont.systemFont(ofSize: 12, weight: .semibold)) }.reduce(0, +)
        
        let totalSpacing = Double(genres.count) * spacing
        let totalpadding = Double(genres.count) * (2 * horizontalPadding)
        
        let totalFrameWidth: CGFloat = totalSpacing + totalpadding + totalStringWidth
        return totalFrameWidth >= geometry.size.width
    }
    
    @ViewBuilder
    func GenreIcon(genre: GenreResponse) -> some View {
        if let name = genre.name, let id = genre.id {
            Text(name)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(fontColor)
                .padding(.vertical, 3)
                .padding(.horizontal, horizontalPadding)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(fontColor, lineWidth: 2)
                )
        }
    }
}

#Preview {
    let genres: [GenreResponse] = [
        .init(id: 10, name: "Fantasy"),
        .init(id: 11, name: "Comedy"),
        .init(id: 16, name: "Drama"),
        .init(id: 22, name: "Science Fiction"),
        .init(id: 33, name: "Romantic Comedy"),
        .init(id: 17, name: "Adventure"),
        .init(id: 18, name: "Horror")
    ]
    return GenreView(genres: genres)
}

