//
//  AlwaysPopoverUIHostingController.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/17/24.
//

import SwiftUI

// MARK: - UIHostingController

class AlwaysPopoverUIHostingController<Content: View>: UIHostingController<Content> {
    @Binding private var isPresented: Bool
    private let onDismiss: (() -> Void)?

    init(rootView: Content, isPresented: Binding<Bool>, onDismiss: (() -> Void)?) {
        self._isPresented = isPresented
        self.onDismiss = onDismiss
        super.init(rootView: rootView)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = UIColor(AppAssets.formListBgDarkMode)
        } else {
            view.backgroundColor = UIColor(AppAssets.formListBg)
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.isPresented = false

        if let onDismiss = self.onDismiss {
            onDismiss()
        }
    }
}

#Preview {
    MenuPickerDemo()
}
