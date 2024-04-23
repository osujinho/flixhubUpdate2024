//
//  ListViewBuilder.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/20/24.
//

import SwiftUI

struct ListOrGridViewBuilder<Data, Destination, ListView>: View where Data: ForEachCollection, Destination: View, ListView: View, Data.Element: MediaCollection {
    
    @State private var showGridView: Bool = false
    var trailingIcon: String {
        showGridView ? "list.bullet.circle.fill" : "circle.grid.3x3.circle.fill"
    }
    
    let navTitle: String
    let data: Data
    let isLoading: Bool
    let loadMoreData: ((Data.Element) async -> Void)?
    let destination: (Data.Element) -> Destination
    let listView: (Data.Element) -> ListView
    
    var navBarData: NavBarData {
        .init(
            title: navTitle,
            hasBackButton: true,
            trailingIcon: trailingIcon,
            trailingAction: {
                withAnimation(.default) {
                    showGridView.toggle()
                }
            },
            trailingIconColor: .primary
        )
    }
    
    init(
        navTitle: String,
        data: Data,
        isLoading: Bool = false,
        loadMoreData: ((Data.Element) async -> Void)? = nil,
        @ViewBuilder listView: @escaping (Data.Element) -> ListView,
        @ViewBuilder destination: @escaping (Data.Element) -> Destination
    ) {
        self.navTitle = navTitle
        self.data = data
        self.isLoading = isLoading
        self.loadMoreData = loadMoreData
        self.listView = listView
        self.destination = destination
    }
    
    var body: some View {
        ScrollScreenBuilder(navBarData: navBarData) {
            if showGridView {
                GridViewBuilder(
                    data: data,
                    isLoading: isLoading,
                    loadMoreData: loadMoreData,
                    destination: destination
                )
            } else {
                ListViewBuilder(
                    data: data,
                    isLoading: isLoading,
                    loadMoreData: loadMoreData,
                    listView: listView,
                    destination: destination
                )
            }
        }
    }
}
