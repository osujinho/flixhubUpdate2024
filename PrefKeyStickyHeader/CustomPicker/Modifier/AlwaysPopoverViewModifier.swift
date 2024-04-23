//
//  AlwaysPopoverViewModifier.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/17/24.
//

import SwiftUI

// MARK: - Extension

extension View {
    func customPopover<Content>(
        isPresented: Binding<Bool>,
        permittedArrowDirections: UIPopoverArrowDirection = [.up],
        onDismiss: (() -> Void)? = nil,
        content: @escaping () -> Content
    ) -> some View where Content: View {
        self.modifier(AlwaysPopoverViewModifier(
            isPresented: isPresented,
            permittedArrowDirections: permittedArrowDirections,
            onDismiss: onDismiss,
            content: content
        ))
    }
}

// MARK: - Modifier

struct AlwaysPopoverViewModifier<PopoverContent>: ViewModifier where PopoverContent: View {
    @Binding var isPresented: Bool
    let permittedArrowDirections: UIPopoverArrowDirection
    let onDismiss: (() -> Void)?
    let content: () -> PopoverContent

    init(
        isPresented: Binding<Bool>,
        permittedArrowDirections: UIPopoverArrowDirection,
        onDismiss: (() -> Void)? = nil,
        content: @escaping () -> PopoverContent
    ) {
        self._isPresented = isPresented
        self.permittedArrowDirections = permittedArrowDirections
        self.onDismiss = onDismiss
        self.content = content
    }

    func body(content: Content) -> some View {
        content
            .background(
                AlwaysPopoverViewController(
                    isPresented: self.$isPresented,
                    permittedArrowDirections: self.permittedArrowDirections,
                    onDismiss: self.onDismiss,
                    content: self.content
                )
            )
    }
}
