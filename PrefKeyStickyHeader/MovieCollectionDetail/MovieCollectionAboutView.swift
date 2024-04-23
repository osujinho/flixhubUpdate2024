//
//  MovieCollectionAboutView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/2/24.
//

import SwiftUI

struct MovieCollectionAboutView: View {
    
    @EnvironmentObject var fullImageViewModel: FullImageViewModel
    let detail: MovieCollectionResponse?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            BiographyAndPlotView(overview: detail?.overview, header: "Plot")
            
            if detail?.images != nil {
                Divider()
            }
            
            // Posters
            HorizontalCarouselViewBuilder(
                label: "Posters",
                itemWidth: ImageType.poster.detailCarouselWidth,
                data: detail?.images?.posters,
                destination: { posters in
                    ImageGallery(
                        images: posters,
                        imageType: .poster)
                },
                content: { poster in
                    CarouselItemView(image: poster, imageType: .poster)
                        .onTapGestureModifier {
                            fullImageViewModel.displaySlideView(detail?.images?.posters, image: poster, imageType: .poster)
                        }
                }
            )
            
            // Tagged Backdrops
            HorizontalCarouselViewBuilder(
                label: "Backdrops",
                itemWidth: ImageType.backdrop.detailCarouselWidth,
                data: detail?.images?.backdrops,
                destination: { backdrops in
                    ImageGallery(
                        images: backdrops,
                        imageType: .backdrop)
                },
                content: { backdrop in
                    CarouselItemView(image: backdrop, imageType: .backdrop)
                        .onTapGestureModifier {
                            fullImageViewModel.displaySlideView(detail?.images?.backdrops, image: backdrop, imageType: .backdrop)
                        }
                }
            )
        }
    }
}
