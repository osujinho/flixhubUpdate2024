//
//  AndOrSelection.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/21/24.
//

import SwiftUI

enum AndOrSelection: EnumPickable {
    case and, or
    
    var id: AndOrSelection { self }
    
    var description: String {
        switch self {
        case .and: return "AND"
        
        case .or: return "OR"
        }
    }
}

protocol AndOrSelectable {
    associatedtype T: Pickable
    var value: Set<T> { get }
    var andOr: AndOrSelection { get }
}

// Provide a default implementation for formattedValue
extension AndOrSelectable {
    var formattedValue: String {
        let separator: String
        switch andOr {
        case .and:
            separator = ", "
        case .or:
            separator = " | "
        }
        return value.map { $0.description }.joined(separator: separator)
    }
}

//enum AndOrSelection: EnumPickable {
//    case and, or
//    
//    var id: AndOrSelection { self }
//    
//    var description: String {
//        switch self {
//        case .and: return "AND"
//        
//        case .or: return "OR"
//        }
//    }
//}
//
//protocol AndOrSelectable {
//    associatedtype T: CustomStringConvertible & Hashable
//    var value: Binding<Set<T>> { get set }  // Make this property gettable and settable
//    var andOr: Binding<AndOrSelection> { get set }  // Make this property gettable and settable
//}
//
//// Provide a default implementation for formattedValue
//extension AndOrSelectable {
//    var formattedValue: String {
//        let separator: String
//        switch andOr.wrappedValue {
//        case .and:
//            separator = ", "
//        case .or:
//            separator = " | "
//        }
//        return value.wrappedValue.map { $0.description }.joined(separator: separator)
//    }
//}
