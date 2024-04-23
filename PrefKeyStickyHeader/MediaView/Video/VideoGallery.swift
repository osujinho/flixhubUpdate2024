//
//  VideoGallery.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/26/24.
//

import SwiftUI

struct VideoGallery: View {
    
    @Environment(\.dismiss) private var dismiss
    let videos: [VideoDetail]
    private let thumbnailWidth: CGFloat = 300
    private var navBarData: NavBarData = .init(
        title: "Videos", 
        hasBackButton: true
    )
    
    init(videos: [VideoDetail]) {
        self.videos = videos
    }
    
    var body: some View {
        ScrollScreenBuilder(navBarData: navBarData) {
            ForEach(videos, id: \.self) { clip in
                VideoPlayer(video: clip, showTitle: true, thumbnailWidth: thumbnailWidth)
            }
        }
    }
}
