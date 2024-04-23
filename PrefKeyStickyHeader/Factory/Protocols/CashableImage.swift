//
//  CashableImage.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/7/24.
//

import SwiftUI

protocol CashableImage {
    subscript(_ path: String) -> UIImage? { get set }
}
