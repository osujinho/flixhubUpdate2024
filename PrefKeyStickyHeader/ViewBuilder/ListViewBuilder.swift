//
//  ListViewBuilder.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/8/24.
//

import SwiftUI

struct ListViewBuilder<Data, Destination, ListView>: View where Data: ForEachCollection, Destination: View, ListView: View, Data.Element: MediaCollection {
    
    let data: Data
    let isLoading: Bool
    let loadMoreData: ((Data.Element) async -> Void)?
    let destination: (Data.Element) -> Destination
    let listView: (Data.Element) -> ListView
    
    init(
        data: Data,
        isLoading: Bool = false,
        loadMoreData: ((Data.Element) async -> Void)? = nil,
        @ViewBuilder listView: @escaping (Data.Element) -> ListView,
        @ViewBuilder destination: @escaping (Data.Element) -> Destination
    ) {
        self.data = data
        self.isLoading = isLoading
        self.loadMoreData = loadMoreData
        self.destination = destination
        self.listView = listView
    }
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            ForEach(data) { dataElement in
                NavigateToView {
                    destination(dataElement)
                } label: {
                    listView(dataElement)
                }
                .task {
                    if let loadMoreData = loadMoreData {
                        await loadMoreData(dataElement)
                    }
                }
            }
            if isLoading && !data.isEmpty {
                CustomLoadingView()
                    .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
            }
        }
        .onEmpty(for: data.isEmpty && !isLoading)
        .simultaneousGesture(
            DragGesture(
                minimumDistance: isLoading ? 0 : .infinity),
            including: .all
        )
    }
}
