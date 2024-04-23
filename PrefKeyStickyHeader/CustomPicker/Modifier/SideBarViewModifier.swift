//
//  SideBarViewModifier.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/9/24.
//

import SwiftUI

struct SideBarViewModifier<SideBarContent: View>: ViewModifier {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var screenSize: CGSize = .zero
//    @State private var slideBarIn: Bool = false
    @Binding var slideBarIn: Bool
    @Binding var showSideBar: Bool
    var sideBarContent: SideBarContent
    
    var direction: Edge = .trailing
    var sideBarWidth: CGFloat { screenSize.width * 0.5 }
    var collapsedNavBarHeight: CGFloat {
        GlobalMethods.collapsedNavBarHeight(safeAreaInsets: safeAreaInsets)
    }
    
    init(showSideBar: Binding<Bool>, slideBarIn: Binding<Bool>, @ViewBuilder sideBarContent: () -> SideBarContent) {
        self._showSideBar = showSideBar
        self._slideBarIn = slideBarIn
        self.sideBarContent = sideBarContent()
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if showSideBar {
                    ZStack(alignment: .trailing) {
                        Color.black
                            .ignoresSafeArea(edges: .all)
                            .opacity(0.6)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    slideBarIn = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        showSideBar.toggle()
                                    }
                                }
                            }
                        
                        if slideBarIn {
                            ZStack(alignment: .topLeading) {
                                AppAssets.backgroundColor
                                    .ignoresSafeArea()
                                
                                VStack(alignment: .leading) {
                                    Color.clear
                                        .frame(height: collapsedNavBarHeight)
                                    
                                    sideBarContent
                                }
                            }
                            .padding(. vertical)
                            .frame(width: sideBarWidth)
                            .transition(.move(edge: direction).combined(with: .opacity))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .ignoresSafeArea()
                    .readSize { newSize in
                        self.screenSize = newSize
                    }
                    .onAppear {
                        withAnimation(.spring()) {
                            slideBarIn = true
                        }
                    }
                }
            }
            .animation(.spring(), value: showSideBar)
    }
}

extension View {
    func sideBarViewModifier<SideBarContent: View>(showSideBar: Binding<Bool>, slideBarIn: Binding<Bool>, @ViewBuilder sideBarContent: () -> SideBarContent) -> some View {
        modifier(SideBarViewModifier(showSideBar: showSideBar, slideBarIn: slideBarIn,  sideBarContent: sideBarContent))
    }
}
