//
//  CastAndCrewView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/1/24.
//

import SwiftUI

struct CastAndCrewView: View {
    
    let casts: [CastResponse]?
    let crew: [CrewResponse]?
    let castLabel: String
    let crewLabel: String
    private let posterWidth: CGFloat = GlobalValues.gridPosterWidth
    
    init(casts: [CastResponse]? = nil, crew: [CrewResponse]? = nil, castLabel: String? = nil, crewLabel: String? = nil) {
        self.casts = casts
        self.crew = crew
        self.castLabel = castLabel ?? "Casts"
        self.crewLabel = crewLabel ?? "Featured Crew"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            OptionalMethods.validOptionalBuilder(value: crew) { crew in
                HorizontalCarouselViewBuilder(
                    label: crewLabel,
                    itemWidth: ImageType.profile.defaultWidth,
                    data: crew,
                    destination: { crew in
                        CreditsView(credits: crew, title: crewLabel)
                    },
                    content: { crew in
                        OptionalMethods.validOptionalBuilder(value: crew.name) { name in
                            NavigateToView {
                                PersonDetailView(personId: crew.id)
                            } label: {
                                PersonProfileView(name: name, poster: crew.poster, role: crew.role, rating: crew.rating, forCarousel: true)
                            }
                        }
                    }
                )
            }
            
            
            OptionalMethods.validOptionalBuilder(value: casts) { casts in
                HorizontalCarouselViewBuilder(
                    label: castLabel,
                    itemWidth: ImageType.profile.defaultWidth,
                    data: casts,
                    destination: { casts in
                        CreditsView(credits: casts, title: castLabel)
                    },
                    content: { cast in
                        OptionalMethods.validOptionalBuilder(value: cast.name) { name in
                            NavigateToView {
                                PersonDetailView(personId: cast.id)
                            } label: {
                                PersonProfileView(name: name, poster: cast.poster, role: cast.role, rating: cast.rating, forCarousel: true)
                            }
                        }
                    }
                )
            }
        }
        .padding(.bottom)
    }
}
