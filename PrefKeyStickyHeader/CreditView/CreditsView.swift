//
//  CreditsView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/20/24.
//

import SwiftUI

struct CreditsView<Credit: MovieAndSeriesCreditCollection>: View {
    
    let credits: [Credit]?
    let title: String?
    
    var navBarData: NavBarData {
        switch credits {
        case is [CastResponse]: return .init(title: title ?? "Casts", hasBackButton: true)
        case is [CrewResponse]: return .init(title: title ?? "Featured Crew", hasBackButton: true)
        default: return .init(title: "", hasBackButton: true)
        }
    }
    
    init(credits: [Credit]?, title: String? = nil) {
        self.credits = credits
        self.title = title
    }
    
    var body: some View {
        OptionalMethods.conditionalOptionalBuilder(credits) { credits in
            
            ScrollScreenBuilder(navBarData: navBarData) {
                ForEach(credits, id: \.self) { credit in
                    if let name = credit.name {
                        NavigateToView {
                            PersonDetailView(personId: credit.id)
                        } label: {
                            PersonProfileView(name: name, poster: credit.picture, role: credit.role, rating: credit.rating)
                        }
                    }
                }
            }
            
        } else: {
            CustomEmptyView(message: "Credit list was not loaded. Please try again!")
        }
    }
}
