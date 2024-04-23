//
//  SeasonDetailView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/27/24.
//

import SwiftUI

struct SeasonDetailView: View {
    
    @StateObject var viewModel: SeasonViewModel
    let seasonNumber: Int
    let seriesHeaderData: SeriesHeaderData
    
    var navBarData: NavBarData {
        .init(
            title: viewModel.seasonDetail?.name ?? "",
            hasBackButton: true,
            trailingIcon: "suit.heart.fill",
            trailingAction: nil,
            trailingIconColor: .white
        )
    }
    
    init(seasonNumber: Int, seriesHeaderData: SeriesHeaderData) {
        self._viewModel = StateObject(wrappedValue: SeasonViewModel(
            service: SeasonAndEpisodeService(),
            seriesId: seriesHeaderData.seriesId,
            seasonNumber: seasonNumber))
        
        self.seasonNumber = seasonNumber
        self.seriesHeaderData = seriesHeaderData
    }
    
    var body: some View {
        
        Group {
            if viewModel.isLoading {
                CustomLoadingView()
            } else if viewModel.hasError {
                ErrorView(message: "Failed to load season details.")
            } else {
                DetailViewBuilder(
                    pickerOptions: $viewModel.seasonPickerOption,
                    navBarData: navBarData,
                    seriesHeaderData: seriesHeaderData,
                    detail: viewModel.seasonDetail,
                    backdrop: { BackdropTabViewBuilder(image: seriesHeaderData.seriesBackdrop) },
                    infoView: { InfoView() },
                    content: {
                        switch viewModel.seasonPickerOption {
                        case .about, .none:
                            SeasonAndEpisodeAboutView(detail: viewModel.seasonDetail)
                        
                        case .episodes:
                            ListViewBuilder(
                                data: viewModel.seasonDetail?.episodes ?? [],
                                isLoading: viewModel.isLoading,
                                listView: { episode in
                                    SeasonAndEpisodeRow(collection: episode)
                                },
                                destination: { episode in
                                    if let episodeNumber = episode.number {
                                        EpisodeDetailView(seriesHeaderData: seriesHeaderData, seasonNumber: seasonNumber, episodeNumber: episodeNumber, totalEpisodes: viewModel.seasonDetail?.totalEpisodes)
                                    }
                                }
                            )
                        
                        case .watchProviders:
                            WatchProviderView(providers: viewModel.seasonDetail?.watchProviders)
                        }
                    }
                )
            }
        }
        .reloadAlertModifier(
            showAlert: $viewModel.hasError,
            title: viewModel.alertTitle,
            message: viewModel.errorMessage
        )
        .alert("No Trailer Available", isPresented: $viewModel.showNoTrailerAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    @ViewBuilder
    func InfoView() -> some View {
        HStack {
            HStack {
                    
                RatingView(rating: viewModel.seasonDetail?.rating, frameSize: GlobalValues.ratingFrameSize)
                
                Text("User\nRating")
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            SeperatorView()
            
            Spacer()
            
            MpaRatingView(rated: seriesHeaderData.seriesMpaRating)
            
            if seriesHeaderData.seriesMpaRating.isValid {
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

//#Preview {
//    SeasonDetailView()
//}
