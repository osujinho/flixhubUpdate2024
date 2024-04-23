//
//  SeriesListView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/15/24.
//

import SwiftUI

struct SeriesListView: View {
    
    let seriesList: [SeriesCollection]
    
    var body: some View {
        ListOrGridViewBuilder(
            navTitle: "TV Series",
            data: seriesList,
            listView: { series in
                CollectionRowView(collection: series)
            },
            destination: { series in
                SeriesDetailView(seriesId: series.id)
            })
    }
}

#Preview {
    SeriesListView(seriesList: mockSeries)
}
