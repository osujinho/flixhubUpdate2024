//
//  VideoPlayerView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/3/24.
//

import SwiftUI
import YouTubePlayerKit

struct VideoPlayerView: View {
    @Environment(\.dismiss) private var dismiss
    let videoID: String
        
    var body: some View {
        ZStack {
            Color("background").edgesIgnoringSafeArea(.all)
            
            GeometryReader { proxy in
                YouTubePlayerView(
                    .init(
                        source: .video(id: videoID),
                        configuration: .init(
                            autoPlay: true,
                            playInline: false
                        )
                    )
                )
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavIconButton(iconName: "chevron.left", circleWidth: 15) {
                    dismiss()
                }
            }
        }
    }
}
