//
//  SeasonPickerOption.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/19/24.
//

import Foundation

enum SeasonPickerOption: EnumPickable {
    case about, episodes, watchProviders

    var id: SeasonPickerOption { self }

    var description: String {
        switch self {
        case .about: return "About"
        case .episodes: return "Episodes"
        case .watchProviders: return "Watch Providers"
        }
    }
}
