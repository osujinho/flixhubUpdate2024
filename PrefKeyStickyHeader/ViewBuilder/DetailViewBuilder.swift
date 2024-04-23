//
//  DetailViewBuilder.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/4/24.
//

import SwiftUI

struct DetailViewBuilder<Enum: EnumPickable, Backdrop: View, InfoView: View, Content: View, TmdbDetail: TmdbMedia>: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var screenSize: CGSize = .zero
    @State private var titleRect: CGRect = .zero
    @State private var backdropRect: CGRect = .zero
    @State private var scrollOffset: CGFloat = 0
    @State private var pickerHeight: CGFloat = 100
    
    @Binding var pickerOptions: Enum?
    var navBarData: NavBarData
    var seriesHeaderData: SeriesHeaderData?
    let detail: TmdbDetail?
    let backdrop: Backdrop
    let content: Content
    let infoView: InfoView
    
    private let bgColor = AppAssets.backgroundColor
    var collapsedNavBarHeight: CGFloat {
        GlobalMethods.collapsedNavBarHeight(safeAreaInsets: safeAreaInsets)
    }
    private var backdropHeightMultiplier: CGFloat {
        detail is PersonResponse ? 0.2 : 0.3
    }
    private var backdropHeight: CGFloat {
        screenSize.height * backdropHeightMultiplier
    }
    
    init(
        pickerOptions: Binding<Enum?>,
        navBarData: NavBarData,
        seriesHeaderData: SeriesHeaderData? = nil,
        detail: TmdbDetail?,
        @ViewBuilder backdrop: () -> Backdrop,
        @ViewBuilder infoView: () -> InfoView,
        @ViewBuilder content: () -> Content
    ) {
        self._pickerOptions = pickerOptions
        self.navBarData = navBarData
        self.seriesHeaderData = seriesHeaderData
        self.detail = detail
        self.backdrop = backdrop()
        self.infoView = infoView()
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { proxy -> AnyView in
            
            DispatchQueue.main.async {
                self.screenSize = proxy.size
            }
            
            return AnyView(
                ZStack {
                    bgColor.ignoresSafeArea(.all)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 10) {
                            GeometryReader { geometry -> AnyView in
                                
                                // Sticky reader
                                let minY = geometry.frame(in: .global).minY
                                
                                DispatchQueue.main.async {
                                    self.scrollOffset = minY
                                }
                                
                                return AnyView(
                                    backdrop
                                        .frame(height: ParalaxManager.getHeightForHeaderImage(geometry))
                                        .clipped()
                                        .blurViewModifier(scrollOffset: scrollOffset, backdropHeight: backdropHeight)
                                        .background(GeometryGetter(rect: self.$backdropRect))
                                        .roundedCorner(10, corners: [.bottomLeft, .bottomRight])
                                        .offset(
                                            y: ParalaxManager.getOffsetForHeaderImage(geometry, collapsedNavBarHeight: collapsedNavBarHeight, backdropHeight: backdropHeight)
                                        )
                                )
                            }
                            .frame(height: backdropHeight)
                            .zIndex(1)
                            
                            VStack {
                                if let seriesHeaderData = seriesHeaderData {
                                    SeasonAndEpisodeHeaderBuilder(
                                        titleRect: $titleRect,
                                        seriesHeaderData: seriesHeaderData,
                                        scrollOffset: scrollOffset,
                                        collapsedNavBarHeight: collapsedNavBarHeight,
                                        backdropHeight: backdropHeight,
                                        detail: detail) {
                                            infoView
                                        }
                                } else {
                                    DetailPosterContainerBuilder(
                                        titleRect: $titleRect,
                                        scrollOffset: scrollOffset,
                                        collapsedNavBarHeight: collapsedNavBarHeight,
                                        backdropHeight: backdropHeight,
                                        detail: detail) {
                                            infoView
                                        }
                                }
                                
                                GeometryReader { pickerProxy in
                                    VStack(spacing: 0) {
                                        CustomPickerView(selection: $pickerOptions, screenWidth: screenSize.width)
                                        
                                        if ParalaxManager.showDivider(pickerProxy, collapsedNavBarHeight: collapsedNavBarHeight) {
                                            Divider()
                                        }
                                    }
                                    .padding(.top, 10)
                                    .background(bgColor)
                                    .offset(
                                        y: ParalaxManager.getPickerOffset(pickerProxy, collapsedNavBarHeight: collapsedNavBarHeight)
                                    )
                                    .geometryHeightReader(height: $pickerHeight)
                                }
                                .frame(height: pickerHeight)
                                .padding(.bottom, 10)
                                .padding(.horizontal, -20)
                                .zIndex(1)

                                content
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 50)
                            }
                            .padding(.horizontal, safeAreaInsets.leading + 20)
                            .zIndex(
                                ParalaxManager.containerZindex(backdropHeight: backdropHeight, collapsedNavBarHeight: collapsedNavBarHeight, scrollOffset: scrollOffset)
                            )
                        }
                    }
                    .ignoresSafeArea(.all)
                }
                .overlay(alignment: .top) {
                    let navBarOffset = proxy.frame(in: .global).minY
                    CustomNavigationBarView(titleRect: titleRect, scrollOffset: navBarOffset, navBarData: navBarData) {
                        ParalaxNavigationTitle()
                    }
                }
                .showImageViewModifier
            )
        }
    }
    
    @ViewBuilder
    func ParalaxNavigationTitle() -> some View {
        
        if let seriesHeaderData = seriesHeaderData {
            if let season = detail as? SeasonDetailResponse {
                Text(seasonName(name: season.name, seasonNumber: season.seasonNumber, seriesName: seriesHeaderData.seriesName ?? ""))
            } else if let episode = detail as? EpisodeDetailResponse {
                Text(episodeName(season: episode.seasonNumber, episode: episode.episodeNumber, seriesName: seriesHeaderData.seriesName ?? "", episodeName: episode.name))
            } else {
                Text(seriesHeaderData.seriesName ?? "")
            }
        } else {
            if let name = detail?.name {
                Text(name)
            } else {
                EmptyView()
            }
        }
    }
    
    private func episodeName(season: Int?, episode: Int?, seriesName: String, episodeName: String?) -> String {
        
        guard season != nil && episode != nil && episodeName != nil else {
            return "\(seriesName) Season N/A - Episode N/A"
        }
        
        if let name = episodeName {
            // Check if both season and episode are provided
            if let season = season, let episode = episode {
                return "\(name) \n\(seriesName) - S\(String(format: "%02d", season))E\(String(format: "%02d", episode))"
            } else {
                return "\(name) \n\(seriesName)"
            }
        } else {
            // Check if both season and episode are provided
            if let season = season, let episode = episode {
                return "\(seriesName) - S\(String(format: "%02d", season))E\(String(format: "%02d", episode))"
            } else {
                return "\(seriesName)"
            }
        }
    }
    
    private func seasonName(name: String?, seasonNumber: Int?, seriesName: String) -> String {
        
        if let name = name {
            return seriesName + " - " + name.capitalized
        } else if let seasonNumber = seasonNumber {
            return seriesName + " - Season \(seasonNumber)"
        } else {
            return seriesName + " Season N/A"
        }
    }
}

#Preview {
    MovieDetailView(movieId: 40108)
}
