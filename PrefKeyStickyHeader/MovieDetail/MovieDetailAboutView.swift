//
//  AboutView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/17/24.
//

import SwiftUI

struct MovieDetailAboutView: View {
    
    let detail: TmdbMovieResponse?
    let omdb: OmdbMovieResponse?
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            GenreView(genres: detail?.genres)
            
            BiographyAndPlotView(overview: detail?.plot, header: "Plot")
            
            Divider()
            
            VerticalLabelContainerBuilder(header: "Information") {
                GridContainer(forAboutView: true) {
                    
                    GridRowSubView.BuildGridRows(for: MovieAboutData.labelItems(
                        detail: detail,
                        omdb: omdb,
                        aboutItems: [.status, .originalTitle, .releaseDate, .originalLanguage])
                    )
                    
                    GridRowSubView.BuildGridRowForArray(for: MovieAboutData.labelArrayItem(
                        detail: detail,
                        omdb: omdb,
                        aboutItem: .spokenLanguages)
                    )
                    
                    GridRowBuilder(label: "Ratings", item: omdb?.ratings, forAboutView: true) { ratings in
                        CriticsRatingView(ratings: ratings)
                    }
                    
                    GridRowSubView.BuildGridRowForArray(for: MovieAboutData.labelArrayItem(
                        detail: detail,
                        omdb: omdb,
                        aboutItem: .awards)
                    )
                    
                    GridRowSubView.BuildGridRows(for: MovieAboutData.labelItems(
                        detail: detail,
                        omdb: omdb,
                        aboutItems: [.dvdReleaseDate, .budget, .boxOffice, .revenue])
                    )
                    
                    GridRowSubView.BuildGridRowForArray(for: MovieAboutData.labelArrayItem(
                        detail: detail,
                        omdb: omdb,
                        aboutItem: .productionCompanies)
                    )
                    
                    GridRowSubView.BuildGridRowForArray(for: MovieAboutData.labelArrayItem(
                        detail: detail,
                        omdb: omdb,
                        aboutItem: .productionCountries)
                    )
                }
            }
            
            OptionalMethods.validOptionalBuilder(value: detail?.collection) { collection in
                
                Divider()
                
                VerticalLabelContainerBuilder(header: "Collection") {
                    
                    OptionalMethods.conditionalOptionalBuilder(collection.id) { collectionId in
                        NavigateToView {
                            MovieCollectonDetailView(collectionId: collectionId)
                        } label: {
                            MovieCollectionRow(name: collection.name)
                        }
                    } else: {
                        MovieCollectionRow(name: collection.name)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func MovieCollectionRow(name: String?) -> some View {
        
        let collectionName: String = name?.removeExtraSpaces ?? "Collection"
        
        CustomAsyncImage(
            path: detail?.collection?.backdrop,
            placeholder: {
                ImageType.backdrop.placeholder
            },
            image: {
                Image(uiImage: $0)
                    .resizable()
            }
        )
        .aspectRatio(contentMode: .fill)
        .gradientOverlayModifier(color: AppAssets.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            VStack(spacing: 50) {
                let bgOpacity: Double = 0.5
                
                Text("Belongs to " + collectionName)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background(Color.black.opacity(bgOpacity))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Text("See collection")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background(Color.black.opacity(bgOpacity))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        )
    }
}
