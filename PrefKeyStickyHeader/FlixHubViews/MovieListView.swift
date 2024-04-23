//
//  MovieListView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/21/24.
//

import SwiftUI

struct MovieListView: View {
    
    var movies: [MovieCollection]
    
    var body: some View {
        ListOrGridViewBuilder(
            navTitle: "Movies",
            data: movies,
            listView: { movie in
                CollectionRowView(collection: movie)
            },
            destination: { movie in
                MovieDetailView(movieId: movie.id)
            })
    }
}

#Preview {
    MovieListView(movies: mockTmdbMovieResult)
}
