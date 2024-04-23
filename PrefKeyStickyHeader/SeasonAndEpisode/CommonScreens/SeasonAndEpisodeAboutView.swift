//
//  SeasonAboutView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/28/24.
//

import SwiftUI

struct SeasonAndEpisodeAboutView<TmdbDetail: TmdbMedia>: View {
    
    @EnvironmentObject var fullImageViewModel: FullImageViewModel
    let detail: TmdbDetail?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            BiographyAndPlotView(overview: detail?.plot, header: "Plot")
            
            Divider()
            
            VerticalLabelContainerBuilder(header: "Information") {
                GridContainer(forAboutView: true) {
                    GridRowBuilder(label: "Aired On", item: detail?.date, forAboutView: true) { airdate in
                        Text(GlobalMethods.formatDate(airdate, fullDate: true))
                    }
                    
                    if let totalEpisodes = (detail as? SeasonDetailResponse)?.totalEpisodes {
                        GridRowBuilder(label: "Total Episodes", item: totalEpisodes, forAboutView: true) { totalEpisodes in
                            Text("\(totalEpisodes)")
                        }
                    }
                }
            }
            
            // Videos
            if let videos = (detail as? SeasonDetailResponse)?.videos ?? (detail as? EpisodeDetailResponse)?.videos {
                
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
            }
            
            // Images
            if let posters = (detail as? SeasonDetailResponse)?.images?.posters ?? (detail as? EpisodeDetailResponse)?.images?.posters {
                
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
            }
            
            // Backdrops
            if let images = (detail as? SeasonDetailResponse)?.images ?? (detail as? EpisodeDetailResponse)?.images {
                
                let backdrops = [images.backdrops, images.stills].compactMap { $0 }.flatMap { $0 }
                
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
        }
    }
}
