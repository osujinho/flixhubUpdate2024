//
//  PersonAboutView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/4/24.
//

import SwiftUI

struct PersonAboutView: View {
    
    @EnvironmentObject var fullImageViewModel: FullImageViewModel
    let detail: PersonResponse?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            VerticalLabelContainerBuilder(header: "Information") {
                GridContainer(forAboutView: true) {
                    GridRowBuilder(label: "Birthday", item: detail?.birthday, forAboutView: true) { birthday in
                        Text(GlobalMethods.formatDate(birthday, fullDate: true))
                    }
                    
                    OptionalMethods.validOptionalBuilder(value: detail?.deathday) { deathday in
                        GridRowBuilder(label: "Died on", item: deathday, labelColor: Color.red.opacity(0.7), forAboutView: true) { birthday in
                            Text(GlobalMethods.formatDate(deathday, fullDate: true))
                        }
                    }
                    
                    GridRowBuilder(label: "Place of Birth", item: detail?.birthPlace, forAboutView: true) { birthPlace in
                        Text(birthPlace.removeExtraSpaces)
                    }
                }
            }
            
            BiographyAndPlotView(overview: detail?.biography, header: "Biography")
            
            Divider()
            
            // Images
            HorizontalCarouselViewBuilder(
                label: "Images",
                itemWidth: ImageType.profile.detailCarouselWidth,
                data: detail?.images,
                destination: { images in
                    ImageGallery(
                        images: images,
                        imageType: .profile)
                },
                content: { image in
                    CarouselItemView(image: image, imageType: .profile)
                        .onTapGestureModifier {
                            fullImageViewModel.displaySlideView(detail?.images, image: image, imageType: .profile)
                        }
                }
            )
            
            // Tagged Posters
            HorizontalCarouselViewBuilder(
                label: "Tagged Posters",
                itemWidth: ImageType.poster.detailCarouselWidth,
                data: detail?.taggedImages?.posters,
                destination: { posters in
                    ImageGallery(
                        images: posters,
                        imageType: .poster)
                },
                content: { poster in
                    CarouselItemView(image: poster, imageType: .poster)
                        .onTapGestureModifier {
                            fullImageViewModel.displaySlideView(detail?.taggedImages?.posters, image: poster, imageType: .poster)
                        }
                }
            )
            
            // Tagged Backdrops
            HorizontalCarouselViewBuilder(
                label: "Tagged Backdrops",
                itemWidth: ImageType.backdrop.detailCarouselWidth,
                data: detail?.taggedImages?.backdrops,
                destination: { backdrops in
                    ImageGallery(
                        images: backdrops,
                        imageType: .backdrop)
                },
                content: { backdrop in
                    CarouselItemView(image: backdrop, imageType: .backdrop)
                        .onTapGestureModifier {
                            fullImageViewModel.displaySlideView(detail?.taggedImages?.backdrops, image: backdrop, imageType: .backdrop)
                        }
                }
            )
        }
    }
}
