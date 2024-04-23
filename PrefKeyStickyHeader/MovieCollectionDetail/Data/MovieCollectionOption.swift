//
//  MovieCollectionOption.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/2/24.
//

import Foundation

enum MovieCollectionOption: EnumPickable {
    case collection, about

    var id: MovieCollectionOption { self }

    var description: String {
        switch self {
        case .about: return "About"
        case .collection: return "Collection"
        }
    }
}
