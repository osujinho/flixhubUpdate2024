//
//  IntIdentifiable.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/10/24.
//

import Foundation

protocol IntIdentifiable: EnumPickable {
    var id: Int { get }
}
