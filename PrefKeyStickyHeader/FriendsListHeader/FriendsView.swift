//
//  FriendsView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 12/7/23.
//

import SwiftUI

struct FriendsView: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.colorScheme) var scheme
    @State private var searchQuerry: String = ""
    
    // Offsets
    @State private var offset: CGFloat = 0
    @State private var startOffset: CGFloat = 0
    
    // To move title to the center
    // We need the title width
    @State private var titleOffset: CGFloat = 0
    
    // To get the scrollview padded from the top
    // We are going to get the height of the title bar
    @State private var titleBarHeight: CGFloat = 0
    
    var collapsedNavBarHeight: CGFloat {
        safeAreaInsets.top + 15
    }
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            AppAssets.backgroundColor.ignoresSafeArea(.all)
            
            
            VStack {
                
                if searchQuerry == "" {
                    HStack {
                        Button(action: {}, label: {
                            Image(systemName: "star")
                                .font(.title2)
                                .foregroundColor(.primary)
                        })
                        
                        Spacer()
                        
                        Button(action: {}, label: {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.primary)
                        })
                    }
                    .padding()
                    
                    HStack {
                        (
                            Text("My ")
                                .fontWeight(.bold)
                                .foregroundColor(.primary)

                            +
                            
                            Text("friends")
                                .foregroundColor(.gray)
                        )
                        .font(.largeTitle)
                        .overlay(alignment: .top) {
                            GeometryReader { proxy -> Color in
                                
                                let width = proxy.frame(in: .global).maxX
                                
                                DispatchQueue.main.async {
                                    
                                    if titleOffset == 0 {
                                        titleOffset = width
                                    }
                                }
                                
                                return Color.clear
                            }
                            .frame(width: 0, height: 0)
                        }
                        .padding()
                        // scaling
                        .scaleEffect(getScale())
                        // getting offset and moving the view
                        .offset(getTitleOffset())
                        
                        Spacer()
                    }
                }
                
                VStack {
                    // MARK: - Search Bar
                    HStack(spacing: 15) {
                        
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 23, weight: .bold))
                            .foregroundColor(.gray)
                        
                        TextField("Search", text: $searchQuerry)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.primary.opacity(0.05))
                    .cornerRadius(8)
                    .padding()
                    
                    if searchQuerry == "" {
                        // Divider Line
                        HStack {
                            Text("RECENTS")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.6))
                                .frame(height: 0.5)
                        }
                        .padding()
                    }
                }
                // 30 is the height of the TextField including the 10 vertical padding
                .offset(y: offset > 0 && searchQuerry == "" ? (offset <= (collapsedNavBarHeight + 30) ? -offset : -(collapsedNavBarHeight + 30)) : 0)
            }
            .zIndex(1)
            // padding bottom
            // to decrease height of the view
            .padding(.bottom, searchQuerry == "" ? getTitleOffset().height : 0)
            .background(
                ZStack {
                    let bgColor = AppAssets.backgroundColor
                    
                    LinearGradient(
                        gradient: .init(colors: [bgColor, bgColor, bgColor, bgColor, bgColor.opacity(0.6)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .ignoresSafeArea()
            )
            .overlay {
                GeometryReader { proxy -> Color in
                    
                    let height = proxy.frame(in: .global).maxY
                    
                    DispatchQueue.main.async {
                        if titleBarHeight == 0 {
                            titleBarHeight = height - safeAreaInsets.top
                        }
                    }
                    
                    return Color.clear
                }
            }
            // animating only if user starts typing
            .animation(.easeInOut, value: searchQuerry != "")
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15) {
                    
                    // Do not use this filter method
                    // It is just for tutorial
                    
                    let myFriends = searchQuerry == "" ? friends : friends.filter { $0.name.lowercased().contains(searchQuerry.lowercased()) }
                    
                    ForEach(myFriends) { friend in
                        FriendCardRowView(friend: friend)
                    }
                }
                .padding(.top, 10)
                .padding(.top, searchQuerry == "" ? titleBarHeight : 90)
                // get offset by geometry reader
                .overlay(alignment: .top) {
                    GeometryReader { proxy -> Color in
                        
                        let minY = proxy.frame(in: .global).minY
                        
                        DispatchQueue.main.async {
                            
                            // To get original offset
                            // that is from 0
                            // just minus start offset
                            if startOffset == 0 {
                                startOffset = minY
                            }
                            
                            offset = startOffset - minY
                        }
                        
                        return Color.clear
                    }
                    .frame(width: 0, height: 0)
                }
            }
        }
    }
    
    private func getTitleOffset() -> CGSize {
        
        var size: CGSize = .zero
        let screenWidth = UIScreen.main.bounds.width / 2
        
        // Since width is slow moving
        // we will multiply by 1.5
        size.width = offset > 0 ? (offset * 1.5 <= (screenWidth - titleOffset) ? offset * 1.5 : (screenWidth - titleOffset)) : 0
        size.height = offset > 0 ? (offset <= collapsedNavBarHeight ? -offset : -collapsedNavBarHeight) : 0
        return size
    }
    
    // A little bit shrinking title when scrolling...
    private func getScale() -> CGFloat {
        if offset > 0 {
            let screenWidth = UIScreen.main.bounds.width
            
            let progress = 1 - (getTitleOffset().width / screenWidth)
            
            return progress >= 0.9 ? progress : 0.9
        } else {
            return 1
        }
    }
}

#Preview {
    FriendsView()
        .preferredColorScheme(.dark)
}
