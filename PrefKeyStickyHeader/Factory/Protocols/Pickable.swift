//
//  Pickable.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 11/30/23.
//

import Foundation

typealias Pickable = Identifiable & Hashable & CustomStringConvertible

typealias EnumPickable = CaseIterable & Pickable

typealias ForEachCollection = RandomAccessCollection & Hashable
