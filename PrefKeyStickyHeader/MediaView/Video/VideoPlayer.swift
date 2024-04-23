//
//  VideoPlayer.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/26/24.
//

import SwiftUI
import YouTubePlayerKit

struct VideoPlayer: View {
    
    @State private var playVideo: Bool = false
    let video: VideoDetail
    let showTitle: Bool
    let thumbnailWidth: CGFloat
    private var thumbnailHeight: CGFloat? {
        ImageType.getHeight(width: thumbnailWidth, imageType: .youtube)
    }
    
    init(video: VideoDetail, showTitle: Bool = false, thumbnailWidth: CGFloat = ImageType.youtube.defaultWidth) {
        self.video = video
        self.showTitle = showTitle
        self.thumbnailWidth = thumbnailWidth
    }
    
    var body: some View {
        
        Group {
            if playVideo {
                VStack(alignment: .leading, spacing: 5) {
                    YouTubePlayerView(
                        .init(
                            source: .video(id: video.key),
                            configuration: .init(
                                autoPlay: true
                            )
                        )
                    )
                    .frame(width: thumbnailWidth , height: thumbnailHeight)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .overlay(alignment: .bottomLeading) {
                        Button(action: {     // To Stop the trailer
                            withAnimation {
                                playVideo = false
                            }
                        }) {
                            Image(systemName: "stop.fill")
                        }
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .offset(x: 2, y: -15)
                    }
                    
                    ShowTitleView
                }
            } else {
                VStack(alignment: .leading, spacing: 5) {
                    Button(action: {
                        withAnimation {
                            playVideo = true
                        }
                    }, label: {
                        CustomAsyncImage(
                            path: video.key,
                            placeholder: {
                                ImageType.youtube.placeholder
                            },
                            image: {
                                Image(uiImage: $0)
                                    .resizable()
                            }
                        )
                        .aspectRatio(contentMode: .fill)
                        .frame(width: thumbnailWidth , height: thumbnailHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    })
                    
                    ShowTitleView
                }
            }
        }
    }
    
    @ViewBuilder
    private var ShowTitleView: some View {
        if showTitle {
            OptionalMethods.validOptionalBuilder(value: video.name) { title in
                Text(title.removeExtraSpaces)
                    .font(.system(size: 13, weight: .semibold))
                    .frame(width: thumbnailWidth, alignment: .topLeading)
            }
        }
    }
}
