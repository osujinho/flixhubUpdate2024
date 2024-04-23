//
//  MediaView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/26/24.
//

import SwiftUI

struct MediaView: View {
    
    @EnvironmentObject var fullImageViewModel: FullImageViewModel
    let videos: [VideoDetail]?
    let posters: [String]?
    let backdrops: [String]?
    
    private var isEmpty: Bool {
        if let posters = posters, let videos = videos, let backdrops = backdrops {
            return posters.isEmpty && videos.isEmpty && backdrops.isEmpty
        } else {
            return false
        }
    }
    
    private let emptyMessage: String = "No Videos and Images are available"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HorizontalCarouselViewBuilder(
                label: "Videos",
                itemWidth: ImageType.youtube.detailCarouselWidth,
                data: videos,
                destination: { videos in
                    VideoGallery(videos: videos)
                },
                content: { video in
                    VideoPlayer(video: video, showTitle: true, thumbnailWidth: ImageType.youtube.detailCarouselWidth)
                }
            )
            
            // Top for posters
            HorizontalCarouselViewBuilder(
                label: "Posters",
                itemWidth: ImageType.poster.detailCarouselWidth,
                data: posters,
                destination: { posters in
                    ImageGallery(
                        images: posters,
                        imageType: .poster)
                },
                content: { poster in
                    CarouselItemView(image: poster, imageType: .poster)
                        .onTapGestureModifier {
                            fullImageViewModel.displaySlideView(posters, image: poster, imageType: .poster)
                        }
                }
            )
            
            // For backdrops
            HorizontalCarouselViewBuilder(
                label: "Backdrops",
                itemWidth: ImageType.backdrop.detailCarouselWidth,
                data: backdrops,
                destination: { backdrops in
                    ImageGallery(
                        images: backdrops,
                        imageType: .backdrop)
                },
                content: { backdrop in
                    CarouselItemView(image: backdrop, imageType: .backdrop)
                        .onTapGestureModifier {
                            fullImageViewModel.displaySlideView(backdrops, image: backdrop, imageType: .backdrop)
                        }
                }
            )
        }
        .onEmpty(for: isEmpty, with: emptyMessage)
    }
}
