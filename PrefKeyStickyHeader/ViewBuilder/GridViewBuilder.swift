//
//  GridViewBuilder.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/20/24.
//

import SwiftUI

struct GridViewBuilder<Data, Destination>: View where Data : ForEachCollection, Destination : View, Data.Element: MediaCollection {
    
    let data: Data
    let isLoading: Bool
    let loadMoreData: ((Data.Element) async -> Void)?
    let destination: (Data.Element) -> Destination
    
    init(
        data: Data,
        isLoading: Bool = false,
        loadMoreData: ((Data.Element) async -> Void)? = nil,
        @ViewBuilder destination: @escaping (Data.Element) -> Destination
    ) {
        self.data = data
        self.isLoading = isLoading
        self.loadMoreData = loadMoreData
        self.destination = destination
    }
    
    var body: some View {
        LazyVGrid(columns: AppAssets.gridColumns, alignment: .center, spacing: 10) {
            
            ForEach(data) { dataElement in
                NavigateToView {
                    destination(dataElement)
                } label: {
                    PosterGridView(media: dataElement)
                }
                .task {
                    if let loadMoreData = loadMoreData {
                        await loadMoreData(dataElement)
                    }
                }
            }
            
            if isLoading && !data.isEmpty {
                ImageLoadingView()
                    .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
            }
        }
        .onEmpty(for: data.isEmpty)
        .simultaneousGesture(
            DragGesture(
                minimumDistance: isLoading ? 0 : .infinity),
            including: .all
        )
    }
}
