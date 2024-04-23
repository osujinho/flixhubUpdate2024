//
//  ErrorAlertable.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/6/24.
//

import Foundation

protocol ErrorAlertable: Identifiable, Hashable {
    var alertTitle: String { get }
    var alertMessage: String { get }
}
