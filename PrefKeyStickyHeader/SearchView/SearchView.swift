//
//  SearchView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/11/24.
//

import SwiftUI

struct SearchView: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject private var viewModel: SearchViewModel
    @State private var isEditing = false
    @State private var titleRect: CGRect = .zero
    @State private var screenSize: CGSize = .zero
    @Namespace var namespace
    private let matchedGeometryId: String = "SearchBar"

    var collapsedNavBarHeight: CGFloat {
        GlobalMethods.collapsedNavBarHeight(safeAreaInsets: safeAreaInsets)
    }
    var navBarData: NavBarData {
        .init(
            title: "Search Media",
            hasBackButton: true,
            trailingIcon: nil,
            trailingAction: nil,
            trailingIconColor: .primary
        )
    }
    private let bgColor: Color = AppAssets.backgroundColor
    
    init() {
        self._viewModel = StateObject(wrappedValue: SearchViewModel(service: SearchService()))
    }
    
    var body: some View {
        
        GeometryReader { proxy -> AnyView in
            
            DispatchQueue.main.async {
                self.screenSize = proxy.size
            }
            
            return AnyView(
                
                CustomNavigationView(titleRect: titleRect, navBarData: navBarData, searchBarIsEditing: isEditing, searchBarView: {
                    ScopeSearchBar()
                }, content: {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 10) {
                            
                            if !isEditing {
                                GeometryReader { geometry in
                                    
                                    // MARK: - Navigation title and Search bar
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text(navBarData.title)
                                            .font(.system(size: 32, weight: .bold))
                                            .padding(.horizontal)
                                            .background(GeometryGetter(rect: $titleRect))
                                        
                                        GeometryReader { searchBarProxy in
                                            
                                            ZStack {
                                                bgColor
                                                
                                                SearchBarWithScope(scopeOptions: $viewModel.searchScopeOption, searchText: $viewModel.searchText, isEditing: $isEditing, namespace: namespace, matchedGeometryId: matchedGeometryId, screenWidth: screenSize.width, cancelAction: { viewModel.cancelAction() })
                                                    .padding(.horizontal)
                                                    .background {
                                                        if showSearchBarOpaqueBg(geometry) {
                                                            Color.clear
                                                                .background(.ultraThinMaterial)
                                                                .blur(radius: 0.5)
                                                        }
                                                    }
                                            }
                                            .offset(y: getSearchBarOffset(searchBarProxy))
                                        }
                                    }
                                }
                                .frame(height: 90)
                                .zIndex(1)
                            }
                            
                            Group {
                                switch viewModel.searchScopeOption {
                                case .movie, .none:
                                    ListViewBuilder(
                                        data: viewModel.movies,
                                        isLoading: viewModel.isLoading,
                                        loadMoreData: { movie in
                                            await viewModel.loadMoreMoviesIfNeeded(currentMovie: movie)
                                        },
                                        listView: { movie in
                                            CollectionRowView(collection: movie)
                                        },
                                        destination: { movie in
                                            MovieDetailView(movieId: movie.id)
                                        }
                                    )
                                
                                case .series:
                                    ListViewBuilder(
                                        data: viewModel.fetchedSeries,
                                        isLoading: viewModel.isLoading,
                                        loadMoreData: { series in
                                            await viewModel.loadMoreSeriesIfNeeded(currentSeries: series)
                                        },
                                        listView: { series in
                                            CollectionRowView(collection: series)
                                        },
                                        destination: { series in
                                            SeriesDetailView(seriesId: series.id)
                                        }
                                    )
                                
                                case .person:
                                    ListViewBuilder(
                                        data: viewModel.people,
                                        isLoading: viewModel.isLoading,
                                        loadMoreData: { person in
                                            await viewModel.loadMorePeopleIfNeeded(currentPerson: person)
                                        },
                                        listView: { person in
                                            CollectionRowView(collection: person)
                                        },
                                        destination: { person in
                                            PersonDetailView(personId: person.id)
                                        }
                                    )
                                }
                            }
                            .padding(.vertical, isEditing ? collapsedNavBarHeight : 20)
                            .padding(.horizontal)
                        }
                    }
                    .scrollDismissesKeyboard(.immediately)
                })
                .reloadAlertModifier(showAlert: $viewModel.hasError,
                    title: viewModel.searchAlert.alertTitle,
                    message: viewModel.searchAlert.alertMessage
                )
                .overlay {
                    if viewModel.isLoading && viewModel.isAllEmpty {
                        CustomLoadingView()
                    }
                }
            )
        }
    }
    
    @ViewBuilder
    func ScopeSearchBar() -> some View {
        SearchBarWithScope(scopeOptions: $viewModel.searchScopeOption, searchText: $viewModel.searchText, isEditing: $isEditing, namespace: namespace, matchedGeometryId: matchedGeometryId, screenWidth: screenSize.width, cancelAction: { viewModel.cancelAction() })
            .padding(.top, safeAreaInsets.top)
            .padding(.horizontal)
            .background {
                Color.clear
                    .background(.ultraThinMaterial)
                    .blur(radius: 0.5)
            }
    }
    
    private func getScrollOffset(_ geometry: GeometryProxy, forMinY: Bool = true) -> CGFloat {
        forMinY ? geometry.frame(in: .global).minY : geometry.frame(in: .global).maxY
    }
    
    private func getSearchBarOffset(_ geometry: GeometryProxy) -> CGFloat {
        let searchBarOffset = getScrollOffset(geometry)
        return searchBarOffset < collapsedNavBarHeight ? -searchBarOffset + collapsedNavBarHeight : 0
    }
    
    private func showSearchBarOpaqueBg(_ geometry: GeometryProxy) -> Bool {
        let searchBarOffset = getScrollOffset(geometry)
        return searchBarOffset < (collapsedNavBarHeight * 0.5)
    }
}

#Preview {
    SearchView()
}
