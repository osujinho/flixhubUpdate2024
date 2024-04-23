//
//  OptionalMethods.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/22/24.
//

import SwiftUI

enum OptionalMethods {
    
    static func unwrapNumbersToString(_ number: Int?) -> String {
        guard let number = number else { return GlobalValues.defaultWrappedString }
        return String(number)
    }
    
    // MARK: - With else Blocks
    static func conditionalOptionalBuilder<T, ThenView: View, ElseView: View>(
        _ value: Optional<T>,
        @ViewBuilder then thenFunction: @escaping (T) -> ThenView,
        @ViewBuilder else elseFunction: @escaping () -> ElseView
    ) -> some View {

        switch value {
        case .some(let unwrappedValue):
            if value.isValid {
                return AnyView(thenFunction(unwrappedValue))
            } else {
                return AnyView(elseFunction())
            }
        case .none: return AnyView(elseFunction())
        }
    }
    
    // MARK: - Without Else Blocks
    static func validOptionalBuilder<T, ValidView: View>(
        value: T?, 
        @ViewBuilder validView: @escaping (T) -> ValidView
    ) -> some View {
        
        Group {
            if let unwrappedValue = value, value.isValid {
                validView(unwrappedValue)
            } else {
                EmptyView()
            }
        }
    }
    
//    static func isValid<T>(_ value: T?) -> Bool {
//        
//        guard let unwrappedValue = value else { return false }
//        
//        switch unwrappedValue {
//        case let string as String:
//            return !GlobalValues.unwantedStrings.contains(string)
//        case let double as Double:
//            return double > 0
//        case let int as Int:
//            return int > 0
//        case let array as any ForEachCollection:
//            return !array.isEmpty
//        default:
//            return true
//        }
//    }
}
