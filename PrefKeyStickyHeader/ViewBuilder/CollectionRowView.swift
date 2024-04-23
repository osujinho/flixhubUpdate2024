//
//  CollectionRowView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/5/24.
//

import SwiftUI

struct CollectionRowView<CollectionData: MediaCollection>: View {
    
    let collection: CollectionData
    var rating: Double? {
        collection.rating
    }
    var posterWidth: CGFloat
    var titleFontSize: CGFloat {
        posterWidth * 0.16
    }
    
    init(collection: CollectionData, posterWidth: CGFloat = 113) {
        self.collection = collection
        self.posterWidth = posterWidth
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 30) {
            PosterListView(posterPath: collection.poster, rating: rating, posterWidth: posterWidth)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(collection.name?.capitalized ?? GlobalValues.defaultWrappedString)
                    .font(.system(size: titleFontSize, weight: .semibold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 5)
                
                // MARK: - Movie
                if let movie = collection as? MovieCollection {
                    GridRowSubView.CollectionGridView(
                        items: [
                            LabelGridItemData(
                                label: "Movie",
                                content: GlobalMethods.formatDate(movie.releaseDate)
                            )
                        ]
                    )
                    GridRowSubView.SingleStringView(text: GenreManager.firstThree(genreIds: movie.genreIds, isMovie: true))
                }
                
                // MARK: - Series
                if let series = collection as? SeriesCollection {
                    GridRowSubView.CollectionGridView(
                        items: [
                            LabelGridItemData(
                                label: "Series",
                                content: GlobalMethods.formatDate(series.firstAirDate)
                            )
                        ]
                    )
                    GridRowSubView.SingleStringView(text: GenreManager.firstThree(genreIds: series.genreIds, isMovie: false))
                }
                
                // MARK: - Person
                if let person = collection as? PersonCollection {
                    GridRowSubView.CollectionGridView(
                        items: [
                            LabelGridItemData(
                                label: GlobalMethods.formatGender(genderNumber: person.gender),
                                content: person.knownForDepartment
                            )
                        ]
                    )
                    
                    ArrayInGridView(items: person.appearsIn)
                }
                
                // MARK: - Person cast Movie
                if let castMovie = collection as? PersonCastMovie {
                    GridRowSubView.CollectionGridView(
                        items: [
                            LabelGridItemData(
                                label: castMovie.mediaType,
                                content: GlobalMethods.formatDate(castMovie.releaseDate)
                            ),
                            LabelGridItemData(
                                label: "Character",
                                content: castMovie.character
                            )
                        ]
                    )
                    
                    GridRowSubView.SingleStringView(text: GenreManager.firstThree(genreIds: castMovie.genreIds, isMovie: true))
                }
                
                // MARK: - Person Cast Series
                if let castSeries = collection as? PersonCastSeries {
                    GridRowSubView.CollectionGridView(
                        items: [
                            LabelGridItemData(
                                label: "Series",
                                content: GlobalMethods.formatDate(castSeries.firstAirDate)
                            ),
                            LabelGridItemData(
                                label: "Character",
                                content: castSeries.character
                            )
                        ]
                    )
                    
                    GridRowSubView.SingleStringView(text: GenreManager.firstThree(genreIds: castSeries.genreIds, isMovie: false))
                }
                
                // MARK: - Person crew Movie
                if let crewMovie = collection as? PersonCrewMovie {
                    GridRowSubView.CollectionGridView(
                        items: [
                            LabelGridItemData(
                                label: crewMovie.mediaType,
                                content: GlobalMethods.formatDate(crewMovie.releaseDate)
                            ),
                            LabelGridItemData(
                                label: "Job",
                                content: crewMovie.job
                            )
                        ]
                    )
                    
                    GridRowSubView.SingleStringView(text: GenreManager.firstThree(genreIds: crewMovie.genreIds, isMovie: true))
                }
                
                // MARK: - Person Cast Series
                if let crewSeries = collection as? PersonCrewSeries {
                    GridRowSubView.CollectionGridView(
                        items: [
                            LabelGridItemData(
                                label: "Series",
                                content: GlobalMethods.formatDate(crewSeries.firstAirDate)
                            ),
                            LabelGridItemData(
                                label: "Job",
                                content: crewSeries.job
                            )
                        ]
                    )
                    
                    GridRowSubView.SingleStringView(text: GenreManager.firstThree(genreIds: crewSeries.genreIds, isMovie: false))
                }
            }
        }
        .font(.system(size: titleFontSize * 0.8))
        .foregroundColor(.secondary)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ZStack {
        AppAssets.backgroundColor
        
        CollectionRowView(collection: lift)
    }
}
