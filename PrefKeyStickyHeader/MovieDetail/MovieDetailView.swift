//
//  MovieDetailView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 12/1/23.
//

import SwiftUI

struct MovieDetailView: View {
    
    @StateObject var viewModel: MovieDetailViewModel
    let movieId: Int
    
    var navBarData: NavBarData {
        .init(
            title: viewModel.tmdbMovieDetail?.title ?? "",
            hasBackButton: true,
            trailingIcon: "suit.heart.fill",
            trailingAction: nil,
            trailingIconColor: .white
        )
    }
    
    init(movieId: Int) {
        self._viewModel = StateObject(wrappedValue: MovieDetailViewModel(
            service: MovieService(),
            movieId: movieId))
        self.movieId = movieId
    }
    
    var body: some View {
        
        Group {
            if viewModel.isLoading {
                CustomLoadingView()
            } else if viewModel.hasError {
                ErrorView(message: "Failed to load movie details.")
            } else {
                DetailViewBuilder(
                    pickerOptions: $viewModel.movieDetailOptions,
                    navBarData: navBarData,
                    detail: viewModel.tmdbMovieDetail,
                    backdrop: { BackdropTabViewBuilder(backdrops: viewModel.tmdbMovieDetail?.images?.backdrops) },
                    infoView: { InfoView() },
                    content: {
                        
                        switch viewModel.movieDetailOptions {
                        case .about, .none:
                            MovieDetailAboutView(detail: viewModel.tmdbMovieDetail, omdb: viewModel.omdbMovieDetail)
                            
                        case .credit:
                            CastAndCrewView(
                                casts: viewModel.tmdbMovieDetail?.credits?.cast,
                                crew: viewModel.tmdbMovieDetail?.credits?.crew
                            )
                            
                        case .watchProviders:
                            WatchProviderView(providers: viewModel.tmdbMovieDetail?.watchProviders)
                            
                        case .media:
                            MediaView(
                                videos: viewModel.tmdbMovieDetail?.videos,
                                posters: viewModel.tmdbMovieDetail?.images?.posters,
                                backdrops: viewModel.tmdbMovieDetail?.images?.backdrops
                            )
                            
                        case .recommended:
                            GridViewBuilder(
                                data: viewModel.recommendedMovies,
                                isLoading: viewModel.isLoadingRecommended,
                                loadMoreData: viewModel.loadMoreRecommendedMovieIfNeeded(currentMovie:),
                                destination: { movie in
                                    MovieDetailView(movieId: movie.id)
                                }
                            )
                            
                        case .similar:
                            GridViewBuilder(
                                data: viewModel.similarMovies,
                                isLoading: viewModel.isLoadingSimilar,
                                loadMoreData: viewModel.loadMoreSimilarMovieIfNeeded(currentMovie:),
                                destination: { movie in
                                    MovieDetailView(movieId: movie.id)
                                }
                            )
                            
                        case .review:
                        ReviewsView(comments: viewModel.tmdbMovieDetail?.reviews)
                        }
                    }
                )
            }
        }
        .reloadAlertModifier(showAlert: $viewModel.hasError,
            title: viewModel.movieDetailAlertOption.alertTitle,
            message: viewModel.movieDetailAlertOption.alertMessage
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
                    
                RatingView(rating: viewModel.tmdbMovieDetail?.rating, frameSize: GlobalValues.ratingFrameSize)
                
                Text("User\nRating")
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            SeperatorView()
            
            Spacer()
            
            MpaRatingView(rated: viewModel.tmdbMovieDetail?.mpaRating ?? viewModel.omdbMovieDetail?.mpaRating)
            
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

#Preview {
    MovieDetailView(movieId: 283566)
}
