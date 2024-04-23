//
//  MovieCollectonDetailView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/2/24.
//

import SwiftUI

struct MovieCollectonDetailView: View {
    
    @StateObject var viewModel: MovieCollectionViewModel
    
    var navBarData: NavBarData {
        .init(
            title: viewModel.collectionDetail?.name ?? "",
            hasBackButton: true,
            trailingIcon: "suit.heart.fill",
            trailingAction: nil,
            trailingIconColor: .white
        )
    }
    
    init(collectionId: Int) {
        self._viewModel = StateObject(wrappedValue: MovieCollectionViewModel(
            service: MovieCollectionService(),
            collectionId: collectionId))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                CustomLoadingView()
            } else if viewModel.hasError {
                ErrorView(message: "Failed to load movie collection detail.")
            } else {
                DetailViewBuilder(
                    pickerOptions: $viewModel.movieCollectionOption,
                    navBarData: navBarData,
                    detail: viewModel.collectionDetail,
                    backdrop: { BackdropTabViewBuilder(image: viewModel.collectionDetail?.backdrop) },
                    infoView: { EmptyView() },
                    content: {
                        
                        switch viewModel.movieCollectionOption {
                        case .about, .none:
                            MovieCollectionAboutView(detail: viewModel.collectionDetail)
                        case .collection:
                            ListViewBuilder(
                                data: viewModel.collectionDetail?.parts ?? [],
                                listView: { movie in
                                    CollectionRowView(collection: movie)
                                },
                                destination: { movie in
                                    MovieDetailView(movieId: movie.id)
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
}

#Preview {
    MovieCollectonDetailView(collectionId: 86311)
}
