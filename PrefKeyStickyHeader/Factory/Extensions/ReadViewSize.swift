//
//  ReadViewSize.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/11/24.
//

import SwiftUI

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
          GeometryReader { geometryProxy in
            Color.clear
              .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
          }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
