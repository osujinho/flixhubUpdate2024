//
//  EpisodeDetailView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/19/24.
//

import SwiftUI

struct EpisodeDetailView: View {
    
    @Environment(\.screenSize) var screenSize
    @StateObject var viewModel: EpisodeViewModel
    let seriesHeaderData: SeriesHeaderData
    let seasonNumber: Int
    let episodeNumber: Int
    
    var navBarData: NavBarData {
        .init(
            title: viewModel.episodeDetail?.name ?? "",
            hasBackButton: true,
            trailingIcon: "suit.heart.fill",
            trailingAction: nil,
            trailingIconColor: .white
        )
    }
    
    init(seriesHeaderData: SeriesHeaderData, seasonNumber: Int, episodeNumber: Int, totalEpisodes: Int?) {
        self.seriesHeaderData = seriesHeaderData
        self.seasonNumber = seasonNumber
        self.episodeNumber = episodeNumber
        
        self._viewModel = StateObject(wrappedValue: EpisodeViewModel(
            service: SeasonAndEpisodeService(),
            seriesId: seriesHeaderData.seriesId,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber, 
            totalEpisodes: totalEpisodes)
        )
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                CustomLoadingView()
            } else if viewModel.hasError {
                ErrorView(message: "Failed to load episode details.")
            } else {
                DetailViewBuilder(
                    pickerOptions: $viewModel.episodePickerOption,
                    navBarData: navBarData,
                    seriesHeaderData: seriesHeaderData,
                    detail: viewModel.episodeDetail,
                    backdrop: { BackdropTabViewBuilder(backdrops: viewModel.episodeDetail?.images?.stills) },
                    infoView: { InfoView() },
                    content: {
                        switch viewModel.episodePickerOption {
                        case .about, .none:
                            SeasonAndEpisodeAboutView(detail: viewModel.episodeDetail)
                            
                        case .credit:
                            CastAndCrewView(
                                casts: viewModel.episodeDetail?.guests,
                                crew: viewModel.episodeDetail?.crew,
                                castLabel: "Guest Stars"
                            )
                        
                        case .watchProviders:
                            WatchProviderView(providers: viewModel.episodeDetail?.watchProviders)
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
        
        VStack(spacing: 10) {
            HStack(alignment: .bottom, spacing: 0) {
                OptionalMethods.validOptionalBuilder(value: viewModel.seasonNumber) { seasonNumber in
                    let description = "\(seriesHeaderData.seriesName ?? "") / Season \(seasonNumber)"
                    Text(description)
                    
                    Spacer()
                        .frame(width: getSpacerLength(description))
                }
                
                PickerMenuBuilder(selection: .single(binding: $viewModel.currentEpisodeNumber), options: viewModel.episodes, menuButtonHeight: 30)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                HStack {
                    
                    RatingView(rating: viewModel.episodeDetail?.rating, frameSize: GlobalValues.ratingFrameSize)
                    
                    Text("User\nRating")
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                SeperatorView()
                
                Spacer()
                
                MpaRatingView(rated: seriesHeaderData.seriesMpaRating)
                
                Spacer()
                
                SeperatorView()
                
                Spacer()
                
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
    
    private func getSpacerLength(_ text: String) -> CGFloat {
        let textWidth = text.widthOfString(usingFont: UIFont.systemFont(ofSize: 13))
        
        let difference = abs(CGFloat(140) - textWidth)
        return difference + 20
    }
}

//#Preview {
//    EpisodeDetailView()
//}
