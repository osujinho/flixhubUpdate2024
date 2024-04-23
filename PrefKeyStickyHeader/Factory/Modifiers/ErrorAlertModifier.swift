//
//  ReloadAlertModifier.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/20/24.
//

import SwiftUI

struct ReloadAlertModifier: ViewModifier {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var showAlert: Bool
    let title: String
    let message: String
    let dismissAction: (() -> Void)?
    
    private let tryAgain: String = " try again later!"
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(title),
                    message: Text(message + tryAgain),
                    dismissButton: .destructive(Text("Ok"), action: {
                        if let dismissAction = dismissAction {
                            dismissAction()
                        } else {
                            dismiss()
                        }
                    })
                )
            }
    }
}

extension View {
    func reloadAlertModifier(showAlert: Binding<Bool>, title: String, message: String, dismissAction: (() -> Void)? = nil) -> some View {
        modifier(ReloadAlertModifier(showAlert: showAlert, title: title, message: message, dismissAction: dismissAction))
    }
}
