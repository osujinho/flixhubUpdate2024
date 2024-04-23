//
//  PersonDetailView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 12/27/23.
//

import SwiftUI

struct PersonDetailView: View {
    
    @StateObject var viewModel: PersonDetailViewModel
    let personId: Int
    var navBarData: NavBarData {
        .init(
            title: viewModel.personDetail?.name ?? "",
            hasBackButton: true,
            trailingIcon: "suit.heart.fill",
            trailingAction: nil,
            trailingIconColor: .white
        )
    }
    
    init(personId: Int) {
        self._viewModel = StateObject(wrappedValue: PersonDetailViewModel(
            service: PersonService(),
            personId: personId))
        self.personId = personId
    }
    
    var body: some View {
        
        Group {
            if viewModel.isLoading {
                CustomLoadingView()
            } else {
                DetailViewBuilder(
                    pickerOptions: $viewModel.personDetailOption,
                    navBarData: navBarData,
                    detail: viewModel.personDetail,
                    backdrop: { BackdropTabViewBuilder(
                        image: viewModel.personDetail?.taggedImages?.backdrops?.first,
                        showGradient: false) },
                    infoView: { InfoView() },
                    content: {
                        switch viewModel.personDetailOption {
                        case .about, .none:
                            PersonAboutView(detail: viewModel.personDetail)
                        
                        case .movies:
                            ListViewBuilder(
                                data: viewModel.personDetail?.credit.movieCasts ?? [],
                                isLoading: viewModel.isLoading,
                                listView: { movie in
                                    CollectionRowView(collection: movie)
                                },
                                destination: { movie in
                                    MovieDetailView(movieId: movie.id)
                                }
                            )
                        
                        case .shows:
                            ListViewBuilder(
                                data: viewModel.personDetail?.credit.tvCasts ?? [],
                                isLoading: viewModel.isLoading,
                                listView: { series in
                                    CollectionRowView(collection: series)
                                },
                                destination: { series in
                                    SeriesDetailView(seriesId: series.id)
                                }
                            )
                        
                        case .crewMovies:
                            ListViewBuilder(
                                data: viewModel.personDetail?.credit.movieCrews ?? [],
                                isLoading: viewModel.isLoading,
                                listView: { movie in
                                    CollectionRowView(collection: movie)
                                },
                                destination: { movie in
                                    MovieDetailView(movieId: movie.id)
                                }
                            )
                        
                        case .crewShows:
                            ListViewBuilder(
                                data: viewModel.personDetail?.credit.tvCrews ?? [],
                                isLoading: viewModel.isLoading,
                                listView: { series in
                                    CollectionRowView(collection: series)
                                },
                                destination: { series in
                                    SeriesDetailView(seriesId: series.id)
                                }
                            )
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
    }
    
    // MARK: - Helper Functions
    
    @ViewBuilder
    func InfoView() -> some View {
        Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 10) {
            
            OptionalMethods.validOptionalBuilder(value: viewModel.personDetail?.knownFor) { knownFor in
                GridRow {
                    Text("Known For")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(knownFor)
                }
            }
            OptionalMethods.validOptionalBuilder(value: viewModel.personDetail?.knownCredits) { knownCredits in
                GridRow {
                    Text("Known Credits")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("\(knownCredits)")
                }
            }
        }
    }
}

#Preview {
    PersonDetailView(personId: 90633)
}
