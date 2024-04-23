//
//  RangeOrSingle.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/21/24.
//

import Foundation

enum RangeOrSingle: EnumPickable {
    case single, range
    
    var id: RangeOrSingle { self }
    
    var description: String {
        switch self {
        case .single: return "Single"
        
        case .range: return "Range"
        }
    }
}
