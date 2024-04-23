//
//  SeasonAndEpisodeRow.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/14/24.
//

import SwiftUI

struct SeasonAndEpisodeRow<CollectionData: SeasonAndEpisodeCollection>: View {
    
    let collection: CollectionData
    var rating: Double? {
        collection.rating
    }
    var isSeason: Bool {
        return ((collection as? SeasonCollection) != nil)
    }
    var imageWidth: CGFloat { isSeason ? 90 : 110 }
    var imageHeight: CGFloat? { ImageType.getHeight(width: imageWidth, imageType: isSeason ? .poster : .backdrop) }
    var titleFontSize: CGFloat { imageWidth * (isSeason ? 0.17 : 0.13) }
    var vStackSpacing: CGFloat { isSeason ? 5 : 2}
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 30) {
            SeasonAndEpisodeListImage(imagePath: collection.image, rating: rating, isPoster: isSeason)
            
            VStack(alignment: .leading, spacing: vStackSpacing) {
                
                // MARK: - Series Season
                if let season = collection as? SeasonCollection {
                    
                    OptionalMethods.validOptionalBuilder(value: season.name) { name in
                        Text(name.removeExtraSpaces.capitalized)
                            .font(.system(size: titleFontSize, weight: .semibold))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, vStackSpacing)
                    }
                    
                    GridRowSubView.CollectionGridView(items: [
                        LabelGridItemData(
                            label: GlobalMethods.formatDate(season.airDate, fullDate: true),
                            content: getTotalEpisodes(season: season)
                        )
                    ])
                }
                
                // MARK: - Season Episode
                if let episode = collection as? EpisodeCollection {
                    
                    OptionalMethods.validOptionalBuilder(value: episode.name) { name in
                        HStack(alignment: .top, spacing: 0) {
                            if let seasonEpisode = formatSeasonEpisode(season: episode.seasonNumber, episode: episode.number) {
                                Text(seasonEpisode + " - ")
                                    .font(.system(size: titleFontSize, weight: .semibold))
                                    .foregroundColor(.primary)
                            }
                            
                            Text(name.removeExtraSpaces.capitalized)
                                .font(.system(size: titleFontSize, weight: .semibold))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.bottom, 5)
                    }
                    
                    GridRowSubView.CollectionGridView(items: [
                        LabelGridItemData(
                            label: GlobalMethods.formatDate(episode.airDate, fullDate: true),
                            content: GlobalMethods.formatRuntime(strTime: episode.runtime)
                        )
                    ])
                }
            }
        }
        .font(.system(size: titleFontSize * 0.9))
        .foregroundColor(.secondary)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func formatSeasonEpisode(season: Int?, episode: Int?) -> String? {
        if let season = season, let episode = episode {
            let formattedSeason = String(format: "%02d", season)
            let formattedEpisode = String(format: "%02d", episode)
            return "S\(formattedSeason)E\(formattedEpisode)"
        }
        return nil
    }
    
    private func getTotalEpisodes(season: SeasonCollection) -> String? {
        if let episodeCount = season.totalEpisodes {
            return episodeCount > 1 ? "\(episodeCount) episodes" : "\(episodeCount) episode"
        }
        return nil
    }
}

#Preview {
    ZStack {
        AppAssets.backgroundColor
        
        VStack {
            SeasonAndEpisodeRow(collection: EpisodeCollection.mockEpisode)
            
            SeasonAndEpisodeRow(collection: SeasonCollection.mockSeason)
        }
        .padding()
    }
}
