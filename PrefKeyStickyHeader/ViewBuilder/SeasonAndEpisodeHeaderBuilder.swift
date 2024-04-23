//
//  SeasonAndEpisodeHeaderBuilder.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/19/24.
//

import SwiftUI

struct SeasonAndEpisodeHeaderBuilder<Content: View, TmdbDetail: TmdbMedia>: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var fullImageViewModel: FullImageViewModel
    @Binding var titleRect: CGRect
    var seriesHeaderData: SeriesHeaderData
    var scrollOffset: CGFloat
    var collapsedNavBarHeight: CGFloat
    var backdropHeight: CGFloat
    let detail: TmdbDetail?
    let content: Content
    
    private let bgColor = AppAssets.backgroundColor
    
    private var forSeason: Bool {
        detail is SeasonDetailResponse
    }
    private var imageWidth: CGFloat {
        forSeason ? ImageType.poster.defaultWidth : 130
    }
    private var imageType: ImageType {
        forSeason ? .poster : .backdrop
    }
    private var imageHeight: CGFloat? {
        ImageType.getHeight(width: imageWidth, imageType: imageType)
    }
    var sizeOffScreen: CGFloat {
        backdropHeight - collapsedNavBarHeight
    }
    var imagePadding: CGFloat = 5
    
    init(titleRect: Binding<CGRect>, seriesHeaderData: SeriesHeaderData, scrollOffset: CGFloat, collapsedNavBarHeight: CGFloat, backdropHeight: CGFloat, detail: TmdbDetail?, @ViewBuilder content: () -> Content) {
        self._titleRect = titleRect
        self.seriesHeaderData = seriesHeaderData
        self.scrollOffset = scrollOffset
        self.collapsedNavBarHeight = collapsedNavBarHeight
        self.backdropHeight = backdropHeight
        self.detail = detail
        self.content = content()
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            // MARK: - Top with Poster
            HStack(alignment: .bottom, spacing: 20) {
                CustomAsyncImage(
                    path: detail?.poster,
                    placeholder: { imageType.placeholder },
                    image: {
                        Image(uiImage: $0)
                            .resizable()
                    }
                )
                .aspectRatio(contentMode: .fill)
                .frame(width: imageWidth, height: imageHeight, alignment: .top)
                .clipShape(RoundedRectangle(cornerRadius: 5.0))
                .padding(imagePadding)
                .background(bgColor.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 5.0))
                .padding(.top, 
                         ParalaxManager.posterOffset(imageHeight: imageHeight, scrollOffset: scrollOffset, sizeOffScreen: sizeOffScreen)
                )
                .offset(x: -imagePadding)
                .scaleEffect(
                    ParalaxManager.posterScaleEffect(
                        scrollOffset: scrollOffset,
                        sizeOffScreen: sizeOffScreen
                    )
                )
                .onTapGestureModifier {
                    fullImageViewModel.displayImage(detail?.poster, imageType: imageType)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(detail?.name ?? GlobalValues.defaultWrappedString)
                            .font(.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.leading)
                            .background(GeometryGetter(rect: $titleRect))
                        
                        if detail is SeasonDetailResponse {
                            Text(seriesHeaderData.seriesName ?? "")
                                .foregroundColor(.secondary)
                                .font(.system(size: 15, weight: .semibold))
                        }
                    }
                    
                    HStack(spacing: 10) {
                        if let season = detail as? SeasonDetailResponse {
                            OptionalMethods.validOptionalBuilder(value: season.date) { date in
                                Text(GlobalMethods.formatDate(date))
                            }
                            
                            if season.totalEpisodes > 0 {
                                if season.date.isValid {
                                    SeperatorView()
                                }
                                Text("\(season.totalEpisodes) episodes")
                            }
                        }
                        
                        if let episode = detail as? EpisodeDetailResponse {
                            OptionalMethods.validOptionalBuilder(value: episode.date) { date in
                                Text(GlobalMethods.formatDate(date))
                            }
                            
                            OptionalMethods.validOptionalBuilder(value: episode.runtime) { runtime in
                                
                                if episode.date.isValid {
                                    SeperatorView()
                                }
                                
                                Text(GlobalMethods.formatRuntime(strTime: runtime))
                            }
                        }
                    }
                    .foregroundColor(.secondary)
                    .font(.system(size: 13))
                }
                
                Spacer()
            }
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            
            // MARK: - Bottom with info
            content
            .foregroundColor(.secondary)
            .font(.system(size: 13))
        }
        .padding(.top, -10)
    }
}
