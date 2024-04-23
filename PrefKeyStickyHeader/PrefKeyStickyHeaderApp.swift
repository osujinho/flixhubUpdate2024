//
//  PrefKeyStickyHeaderApp.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 11/28/23.
//

import SwiftUI

@main
struct PrefKeyStickyHeaderApp: App {
    
    @StateObject var fullImageViewModel = FullImageViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fullImageViewModel)
        }
    }
}
