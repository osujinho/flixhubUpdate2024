//
//  PersonCreditCollection.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/3/24.
//

import Foundation

protocol PersonCreditCollection: MediaCollection {
    var genreIds: [Int]? { get }
    var role: String? { get }
}
