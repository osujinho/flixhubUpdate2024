//
//  EmptyDataViewModifier.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/17/24.
//

import SwiftUI

//MARK: View Modifier
struct EmptyDataViewModifier: ViewModifier {
    let condition: Bool
    let message: String?
    func body(content: Content) -> some View {
        valideView(content: content)
    }
    
    @ViewBuilder
    private func valideView(content: Content) -> some View {
        if condition {
            VStack{
                Spacer()
                Text(wrappedMessage)
                    .font(.system(size: 16))
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                Spacer()
            }
        } else {
            content
        }
    }
    
    private var wrappedMessage: String {
        message ?? "Oops, looks like there's no data..."
    }
}

//MARK: View Extension
extension View {
    func onEmpty(for condition: Bool, with message: String? = nil) -> some View {
        self.modifier(EmptyDataViewModifier(condition: condition, message: message))
    }
}
