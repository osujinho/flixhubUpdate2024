//
//  AlbumData.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/12/24.
//

import Foundation

// MARK: - Album detail

struct Album: Identifiable {
    var id = UUID().uuidString
    var albumName: String
}

var albums: [Album] = [
    Album(albumName: "In Between"),
    Album(albumName: "More"),
    Album(albumName: "Big Jet Plane"),
    Album(albumName: "Empty Floor"),
    Album(albumName: "Black Hole Nights"),
    Album(albumName: "Rain On Me"),
    Album(albumName: "Stuck With U"),
    Album(albumName: "7 Rings"),
    Album(albumName: "Bang Bang"),
    Album(albumName: "In Between"),
    Album(albumName: "More"),
    Album(albumName: "Big Jet Plane"),
    Album(albumName: "Empty Floor"),
    Album(albumName: "Black Hole Nights")
]
