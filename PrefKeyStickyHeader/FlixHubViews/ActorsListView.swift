//
//  AllCastView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/9/24.
//

import SwiftUI

struct ActorsListView: View {
    
    var actors: [PersonCollection]
    
    var body: some View {
        ListOrGridViewBuilder(
            navTitle: "Actors",
            data: actors,
            listView: { actor in
                CollectionRowView(collection: actor)
            },
            destination: { actor in
                PersonDetailView(personId: actor.id)
            })
    }
}

#Preview {
    ActorsListView(actors: mockActors)
}
