//
//  EpisodePickerOption.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/18/24.
//

import Foundation

enum EpisodePickerOption: EnumPickable {
    case about, credit, watchProviders

    var id: EpisodePickerOption { self }

    var description: String {
        switch self {
        case .about: return "About"
        case .credit: return "Credit"
        case .watchProviders: return "Watch Providers"
        }
    }
}
