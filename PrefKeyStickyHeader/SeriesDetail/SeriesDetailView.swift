//
//  SeriesDetailView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/15/24.
//

import SwiftUI

struct SeriesDetailView: View {
    
    @StateObject var viewModel: SeriesDetailViewModel
    let seriesId: Int
    
    var navBarData: NavBarData {
        .init(
            title: viewModel.tmdbSeriesDetail?.name ?? "",
            hasBackButton: true,
            trailingIcon: "suit.heart.fill",
            trailingAction: nil,
            trailingIconColor: .white
        )
    }
    
    var seriesHeaderData: SeriesHeaderData {
        .init(
            seriesId: seriesId,
            seriesName: viewModel.tmdbSeriesDetail?.name,
            seriesMpaRating: viewModel.tmdbSeriesDetail?.mpaRating ?? viewModel.omdbSeriesDetail?.mpaRating,
            seriesBackdrop: viewModel.tmdbSeriesDetail?.images?.backdrops?.first)
    }
    
    init(seriesId: Int) {
        self._viewModel = StateObject(wrappedValue: SeriesDetailViewModel(
            service: SeriesService(),
            seriesId: seriesId))
        self.seriesId = seriesId
    }
    
    var body: some View {
        
        Group {
            if viewModel.isLoading {
                CustomLoadingView()
            } else if viewModel.hasError {
                ErrorView(message: "Failed to load series details.")
            } else {
                DetailViewBuilder(
                    pickerOptions: $viewModel.seriesDetailOptions,
                    navBarData: navBarData,
                    detail: viewModel.tmdbSeriesDetail,
                    backdrop: { BackdropTabViewBuilder(backdrops: viewModel.tmdbSeriesDetail?.images?.backdrops) },
                    infoView: { InfoView() },
                    content: {
                        
                        switch viewModel.seriesDetailOptions {
                        case .about, .none:
                            SeriesAboutView(detail: viewModel.tmdbSeriesDetail, omdb: viewModel.omdbSeriesDetail)
                            
                        case .seasons:
                            ListViewBuilder(
                                data: viewModel.tmdbSeriesDetail?.seasons ?? [],
                                isLoading: viewModel.isLoading,
                                listView: { season in
                                    SeasonAndEpisodeRow(collection: season)
                                },
                                destination: { season in
                                    if let seasonNumber = season.number {
                                        SeasonDetailView(seasonNumber: seasonNumber, seriesHeaderData: seriesHeaderData)
                                    }
                                }
                            )
                            
                        case .credit:
                            CastAndCrewView(
                                casts: viewModel.tmdbSeriesDetail?.credits?.cast,
                                crew: viewModel.tmdbSeriesDetail?.credits?.crew
                            )
                        
                        case .media:
                            MediaView(
                                videos: viewModel.tmdbSeriesDetail?.videos,
                                posters: viewModel.tmdbSeriesDetail?.images?.posters,
                                backdrops: viewModel.tmdbSeriesDetail?.images?.backdrops
                            )
                        
                        case .watchProviders:
                            WatchProviderView(providers: viewModel.tmdbSeriesDetail?.watchProviders)
                            
                        case .recommended:
                            GridViewBuilder(
                                data: viewModel.recommendedSeries,
                                isLoading: viewModel.isLoadingRecommended,
                                loadMoreData: viewModel.loadMoreRecommendedSeriesIfNeeded(currentSeries:),
                                destination: { series in
                                    SeriesDetailView(seriesId: series.id)
                                }
                            )
                        
                        case .similar:
                            GridViewBuilder(
                                data: viewModel.similarSeries,
                                isLoading: viewModel.isLoadingSimilar,
                                loadMoreData: viewModel.loadMoreSimilarSeriesIfNeeded(currentSeries:),
                                destination: { series in
                                    SeriesDetailView(seriesId: series.id)
                                }
                            )
                            
                        case .review:
                            ReviewsView(comments: viewModel.tmdbSeriesDetail?.reviews)
                        }
                    }
                )
            }
        }
        .reloadAlertModifier(
            showAlert: $viewModel.hasError,
            title: viewModel.seriesDetailAlertOption.alertTitle,
            message: viewModel.seriesDetailAlertOption.alertMessage
        )
        .alert("No Trailer Available", isPresented: $viewModel.showNoTrailerAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    // MARK: - Sub Views
    
    @ViewBuilder
    func InfoView() -> some View {
        HStack {
            HStack {
                    
                RatingView(rating: viewModel.tmdbSeriesDetail?.rating, frameSize: GlobalValues.ratingFrameSize)
                
                Text("User\nRating")
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            SeperatorView()
            
            Spacer()
            
            MpaRatingView(rated: viewModel.tmdbSeriesDetail?.mpaRating ?? viewModel.omdbSeriesDetail?.mpaRating)
            
            if viewModel.tmdbSeriesDetail?.mpaRating != nil || viewModel.omdbSeriesDetail?.mpaRating != nil {
                Spacer()
                
                SeperatorView()
                
                Spacer()
            }
            
            NavigationLink(destination: VideoPlayerView(videoID: viewModel.trailerKey), isActive: $viewModel.playTrailer) {
                
                Button(action: {
                    viewModel.checkForTrailer()
                }, label: {
                    HStack(spacing: 10) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 15))
                            .foregroundColor(AppAssets.backgroundColor)
                            .frame(width: GlobalValues.ratingFrameSize + 3, height: GlobalValues.ratingFrameSize + 3)
                            .background(AppAssets.reverseBackground)
                            .clipShape(Circle())
                        
                        Text("Play\nTrailer")
                            .multilineTextAlignment(.leading)
                    }
                })
            }
        }
    }
}

#Preview {
    SeriesDetailView(seriesId: 60574)
}
