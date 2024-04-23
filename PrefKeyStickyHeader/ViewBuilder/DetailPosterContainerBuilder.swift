//
//  DetailPosterContainerBuilder.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/3/24.
//

import SwiftUI

struct DetailPosterContainerBuilder<Content: View, TmdbDetail: TmdbMedia>: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var fullImageViewModel: FullImageViewModel
    @Binding var titleRect: CGRect
    var scrollOffset: CGFloat
    var collapsedNavBarHeight: CGFloat
    var backdropHeight: CGFloat
    let detail: TmdbDetail?
    let content: Content
    
    private let bgColor = AppAssets.backgroundColor
    
    private var forPersonDetail: Bool {
        detail is PersonResponse
    }
    
    private var imageWidth: CGFloat {
        forPersonDetail ? 80 : ImageType.poster.defaultWidth
    }
    private var imageHeight: CGFloat {
        forPersonDetail ? imageWidth : imageWidth * 1.5
    }
    var sizeOffScreen: CGFloat {
        backdropHeight - collapsedNavBarHeight
    }
    var imagePadding: CGFloat {
        forPersonDetail ? 8 : 5
    }
    
    init(titleRect: Binding<CGRect>, scrollOffset: CGFloat, collapsedNavBarHeight: CGFloat, backdropHeight: CGFloat, detail: TmdbDetail?, @ViewBuilder content: () -> Content) {
        self._titleRect = titleRect
        self.scrollOffset = scrollOffset
        self.collapsedNavBarHeight = collapsedNavBarHeight
        self.backdropHeight = backdropHeight
        self.detail = detail
        self.content = content()
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            // MARK: - Top with Poster
            HStack(alignment: .bottom, spacing: 20) {
                CustomAsyncImage(
                    path: detail?.poster,
                    placeholder: { ImageType.poster.placeholder },
                    image: {
                        Image(uiImage: $0)
                            .resizable()
                    }
                )
                .aspectRatio(contentMode: .fill)
                .frame(width: imageWidth, height: imageHeight, alignment: .top)
                .if(forPersonDetail) { view in
                    view
                        .clipShape(Circle())
                }
                .if(!forPersonDetail) { view in
                    view
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                }
                .padding(imagePadding)
                .background(forPersonDetail ? bgColor : bgColor.opacity(0.5))
                .if(forPersonDetail) { view in
                    view
                        .clipShape(Circle())
                }
                .if(!forPersonDetail) { view in
                    view
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                }
                .padding(.top,
                         ParalaxManager.posterOffset(imageHeight: imageHeight, scrollOffset: scrollOffset, sizeOffScreen: sizeOffScreen)
                )
                .offset(x: -imagePadding)
                .scaleEffect(
                    ParalaxManager.posterScaleEffect(
                        scrollOffset: scrollOffset,
                        sizeOffScreen: sizeOffScreen
                    )
                )
                .onTapGestureModifier {
                    fullImageViewModel.displayImage(detail?.poster, imageType: .poster)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(detail?.name ?? GlobalValues.defaultWrappedString)
                            .font(.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(GeometryGetter(rect: $titleRect))
                        
                        if let tagline = (detail as? TmdbMovieResponse)?.tagline ?? (detail as? TmdbSeriesResponse)?.tagline, !tagline.isEmpty {
                            Text(tagline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .italic()
                                .foregroundColor(.secondary)
                                .font(.system(size: 13))
                        }
                    }
                    
                    Group {
                        if let movieDetail = detail as? TmdbMovieResponse {
                            
                            HStack(spacing: 10) {
                                
                                OptionalMethods.validOptionalBuilder(value: movieDetail.releaseDate) { releaseDate in
                                    Text(GlobalMethods.formatDate(releaseDate))
                                }
                                
                                OptionalMethods.validOptionalBuilder(value: movieDetail.runtime) { runtime in
                                    
                                    HStack {
                                        if movieDetail.releaseDate.isValid {
                                            SeperatorView()
                                        }
                                        
                                        Text(GlobalMethods.formatRuntime(strTime: runtime))
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        } else if let seriesDetail = detail as? TmdbSeriesResponse {
                            HStack(spacing: 10) {
                                
                                OptionalMethods.validOptionalBuilder(value: seriesDetail.firstAirDate) { airDate in
                                    
                                    Text(GlobalMethods.formatDate(airDate))
                                }
                                
                                OptionalMethods.validOptionalBuilder(value: seriesDetail.status) { status in
                                    HStack {
                                        if seriesDetail.firstAirDate.isValid || seriesDetail.mpaRating.isValid {
                                            SeperatorView()
                                        }
                                        
                                        Text(status)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        } else if let personDetail = detail as? PersonResponse {
                            HStack(spacing: 10) {
                                OptionalMethods.validOptionalBuilder(value: personDetail.birthday) { birthday in
                                    
                                    HStack(spacing: 0) {
                                        Text(GlobalMethods.getAge(birthDate: birthday, deathDate: personDetail.deathday))
                                        
                                        if personDetail.deathday.isValid {
                                            Text(" (at death)")
                                                .foregroundColor(.red.opacity(0.7))
                                        }
                                    }
                                }
                                
                                OptionalMethods.validOptionalBuilder(value: personDetail.gender) { gender in
                                    
                                    HStack {
                                        if personDetail.birthday.isValid {
                                            SeperatorView()
                                        }
                                        
                                        Text(GlobalMethods.formatGender(genderNumber: personDetail.gender))
                                    }
                                    
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .foregroundColor(.secondary)
                    .font(.system(size: 13))
                }
            }
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            
            // MARK: - Bottom with info
            content
            .foregroundColor(.secondary)
            .font(.system(size: 13))
        }
        .padding(.top, -10)
    }
}

#Preview {
    ActorsListView(actors: mockActors)
}
