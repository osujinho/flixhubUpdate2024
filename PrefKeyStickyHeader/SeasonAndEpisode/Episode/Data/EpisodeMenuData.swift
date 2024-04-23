//
//  EpisodeMenuData.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/11/24.
//

import Foundation

struct EpisodeMenuData: Pickable {
    let episodeNumber: Int

    var id: Int {
        return episodeNumber
    }

    var description: String {
        "Episode \(String(format: "%02d", episodeNumber))"
    }
}
