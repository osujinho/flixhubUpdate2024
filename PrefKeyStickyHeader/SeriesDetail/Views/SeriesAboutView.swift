//
//  SeriesAboutView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/25/24.
//

import SwiftUI

struct SeriesAboutView: View {
    
    let detail: TmdbSeriesResponse?
    let omdb: OmdbSeriesResponse?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            GenreView(genres: detail?.genres)
            
            NetworkView(networks: detail?.networks)
            
            BiographyAndPlotView(overview: detail?.plot, header: "Plot")
            
            VerticalLabelContainerBuilder(header: "Last Episode To Air") {
                OptionalMethods.conditionalOptionalBuilder(detail?.lastEpisode) { lastEpisode in
                    EpisodeInfo(episode: lastEpisode, totalEpisodes: detail?.nextEpisode?.number)
                } else: {
                    Text(GlobalValues.defaultWrappedString)
                }
            }
            
            OptionalMethods.validOptionalBuilder(value: detail?.nextEpisode) { nextEpisode in
                VerticalLabelContainerBuilder(header: "Next Episode") {
                    EpisodeInfo(episode: nextEpisode)
                }
            }
            
            Divider()
            
            VerticalLabelContainerBuilder(header: "Information") {
                GridContainer(forAboutView: true) {
                    
                    GridRowSubView.BuildGridRows(for: SeriesAboutData.labelItems(
                        detail: detail,
                        omdb: omdb,
                        aboutItems: [.type, .originalName, .firstAirDate, .originalLanguage])
                    )
                    
                    GridRowSubView.BuildGridRowForArray(for: SeriesAboutData.labelArrayItem(
                        detail: detail,
                        omdb: omdb,
                        aboutItem: .originCountries)
                    )
                    
                    GridRowSubView.BuildGridRowForArray(for: SeriesAboutData.labelArrayItem(
                        detail: detail,
                        omdb: omdb,
                        aboutItem: .spokenLanguages)
                    )
                    
                    GridRowSubView.BuildGridRows(for: SeriesAboutData.labelItems(
                        detail: detail,
                        omdb: omdb,
                        aboutItems: [.totalSeasons, .totalEpisodes])
                    )
                    
                    GridRowBuilder(label: "Ratings", item: omdb?.ratings, forAboutView: true) { ratings in
                        CriticsRatingView(ratings: ratings)
                    }
                    
                    GridRowSubView.BuildGridRowForArray(for: SeriesAboutData.labelArrayItem(
                        detail: detail,
                        omdb: omdb,
                        aboutItem: .awards)
                    )
                    
                    GridRowSubView.BuildGridRowForArray(for: SeriesAboutData.labelArrayItem(
                        detail: detail,
                        omdb: omdb,
                        aboutItem: .productionCompanies)
                    )
                    
                    GridRowSubView.BuildGridRowForArray(for: SeriesAboutData.labelArrayItem(
                        detail: detail,
                        omdb: omdb,
                        aboutItem: .productionCountries)
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    private func EpisodeInfo(episode: EpisodeCollection, totalEpisodes: Int? = nil) -> some View {
        
        if let seriesId = detail?.id, let episodeNumber = episode.number, let seasonNumber = episode.seasonNumber {
            
            let seriesHeaderData: SeriesHeaderData = .init(
                seriesId: seriesId,
                seriesName: detail?.name,
                seriesMpaRating: detail?.mpaRating ?? omdb?.mpaRating,
                seriesBackdrop: detail?.images?.backdrops?.first
            )
            let episodeCcount = totalEpisodes ?? episode.number
            
            NavigateToView {
                EpisodeDetailView(seriesHeaderData: seriesHeaderData, seasonNumber: seasonNumber, episodeNumber: episodeNumber, totalEpisodes: episodeCcount)
            } label: {
                SeasonAndEpisodeRow(collection: episode)
            }
        } else {
            SeasonAndEpisodeRow(collection: episode)
        }
    }
}
