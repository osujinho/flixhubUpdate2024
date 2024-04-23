//
//  ContentView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 11/28/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var sortCriteria: SortCriteriaOption? = .popularityDesc
    @State var selectedGenres: Set<SeriesGenre>? = []
    @State var selectedYear: YearData? = .year(YearData.currentYear)
    
    @Environment(\.colorScheme) var scheme
    var navBarData: NavBarData {
        .init(
            title: "",
            hasBackButton: false
        )
    }
    
    var body: some View {
        NavigationView {
            
            ScrollScreenBuilder(navBarData: navBarData) {
                VStack(spacing: 30) {
                    HStack {
                        NavigateToView {
                            MovieListView(movies: mockTmdbMovieResult)
                        } label: {
                            NavigationLabel(labelText: "Movies")
                        }
                        
                        Spacer()
                        
                        NavigateToView {
                            ActorsListView(actors: mockActors)
                        } label: {
                            NavigationLabel(labelText: "Actors")
                        }
                        
                        Spacer()
                        
                        NavigateToView {
                            SeriesListView(seriesList: mockSeries)
                        } label: {
                            NavigationLabel(labelText: "Tv Series")
                        }
                    }
                    
                    VerticalLabelContainerBuilder(header: "Sort by", content: {
                        PickerMenuBuilder(selection: .single(binding: $sortCriteria), options: SortCriteriaOption.allCases)
                    })
                    
                    VerticalLabelContainerBuilder(header: "Select Genres", content: {
                        PickerMenuBuilder(selection: .multiple(binding: $selectedGenres), options: SeriesGenre.allCases)
                    })
                    
                    VerticalLabelContainerBuilder(header: "Release Year", content: {
                        PickerMenuBuilder(selection: .single(binding: $selectedYear), options: YearData.allYears)
                    })
                    
                    HStack {
                        Spacer()
                        
                        NavigateToView {
                            SearchView()
                        } label: {
                            NavigationLabel(labelText: "Search")
                        }
                    }
                    
                    Text(loremIpsum)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
    
    @ViewBuilder
    func NavigationLabel(labelText: String) -> some View {
        var fontColor: Color {
            scheme == .dark ? .black : .white
        }
        
        Text(labelText)
            .font(.headline)
            .foregroundColor(fontColor)
            .padding()
            .background(AppAssets.reverseBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ContentView()
    //TwitterProfileView()
}
