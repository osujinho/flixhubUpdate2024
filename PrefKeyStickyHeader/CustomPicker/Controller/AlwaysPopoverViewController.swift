//
//  AlwaysPopoverViewController.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/17/24.
//

import SwiftUI

// MARK: - UIViewController

struct AlwaysPopoverViewController<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let permittedArrowDirections: UIPopoverArrowDirection
    let onDismiss: (() -> Void)?
    @ViewBuilder let content: () -> Content

    init(
        isPresented: Binding<Bool>,
        permittedArrowDirections: UIPopoverArrowDirection,
        onDismiss: (() -> Void)?,
        content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.permittedArrowDirections = permittedArrowDirections
        self.onDismiss = onDismiss
        self.content = content
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, content: self.content())
    }

    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        context.coordinator.host.rootView = self.content()

        guard context.coordinator.lastIsPresentedValue != self.isPresented else { return }

        context.coordinator.lastIsPresentedValue = self.isPresented

        if self.isPresented {
            let host = context.coordinator.host

            if context.coordinator.viewSize == .zero {
                context.coordinator.viewSize = host.sizeThatFits(in: UIView.layoutFittingExpandedSize)
            }

            host.preferredContentSize = context.coordinator.viewSize
            host.modalPresentationStyle = .popover

            host.popoverPresentationController?.delegate = context.coordinator
            host.popoverPresentationController?.sourceView = uiViewController.view
            host.popoverPresentationController?.sourceRect = uiViewController.view.bounds
            host.popoverPresentationController?.permittedArrowDirections = self.permittedArrowDirections
            
            if host.traitCollection.userInterfaceStyle == .dark {
                host.popoverPresentationController?.backgroundColor = UIColor(AppAssets.formListBgDarkMode)
            } else {
                host.popoverPresentationController?.backgroundColor = UIColor(AppAssets.formListBg)
            }

            if let presentedVC = uiViewController.presentedViewController {
                presentedVC.dismiss(animated: true) {
                    uiViewController.present(host, animated: true, completion: nil)
                }
            } else {
                uiViewController.present(host, animated: true, completion: nil)
            }
        } else {
            uiViewController.dismiss(animated: true, completion: nil)
        }
    }

    class Coordinator: NSObject, UIPopoverPresentationControllerDelegate {
        let host: UIHostingController<Content>
        private let parent: AlwaysPopoverViewController

        var lastIsPresentedValue: Bool = false

        /// Content view size.
        var viewSize: CGSize = .zero

        init(parent: AlwaysPopoverViewController, content: Content) {
            self.parent = parent
            self.host = AlwaysPopoverUIHostingController(
                rootView: content,
                isPresented: self.parent.$isPresented,
                onDismiss: self.parent.onDismiss
            )
        }

        func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
//            self.parent.isPresented = false
            withAnimation(.snappy) {
                self.parent.isPresented = false
            }

            if let onDismiss = self.parent.onDismiss {
                onDismiss()
            }
        }

        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none
        }
    }
}
