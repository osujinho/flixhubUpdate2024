//
//  TwitterProfileView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 12/8/23.
//

import SwiftUI

//struct TwitterProfileView: View {
//    @Environment(\.safeAreaInsets) private var safeAreaInsets
//    @Environment(\.colorScheme) var scheme
//    @State private var currentTab = "Tweets"
//    @State private var offset: CGFloat = 0
//    @Namespace var animation
//    
//    var showTabView: Bool {
//        !detail.images.isEmpty
//    }
//    @State private var selectionImageIndex: Int = 0
//    @State private var sliderIsAuto: Bool = true
//    public let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
//    
//    private let user = jasmine
//    let detail: MovieData = oppenheimer
//    private let bgColor = AppAssets.backgroundColor
//    
//    private let headerHeight: CGFloat = 180
//    private let profileImageHeight: CGFloat = 80
//    private let profileImageTopOffset: CGFloat = 20
//    private var collapsedNavBarHeight: CGFloat {
//        safeAreaInsets.top + 20
//    }
//    
//    // MARK: - Picker offset, make it sticky
//    @State private var pickerOffset: CGFloat = 0
//    let pickerHeight: CGFloat = 40
//    
//    // MARK: - For the Navigation title
//    @State private var titleOffset: CGFloat = 0
//    
//    var body: some View {
//        
//        GeometryReader { topProxy in
//            
//            let size = topProxy.size
//            
//            ZStack {
//                AppAssets.backgroundColor.ignoresSafeArea(.all)
//                
//                ScrollView(.vertical, showsIndicators: false) {
//                    
//                    VStack(spacing: 15) {
//                        
//                        // HeaderView
//                        GeometryReader { proxy -> AnyView in
//                            
//                            // Sticky reader
//                            let minY = proxy.frame(in: .global).minY
//                            
//                            DispatchQueue.main.async {
//                                self.offset = minY
//                            }
//                            
//                            return AnyView(
//                                
//                                ZStack {
//                                    // Banner
//                                    VStack {
//                                        if showTabView {
//                                            
//                                            TabView(selection: $selectionImageIndex) {
//                                                ForEach(0..<detail.images.count, id: \.self){ index in
//                                                    let imageName = detail.images[index]
//                                                    ZStack {
//                                                        Image(imageName)
//                                                            .resizable()
//                                                            .aspectRatio(contentMode: .fill)
//                                                        
//                                                        LinearGradient(gradient: Gradient(colors: [.clear, bgColor.opacity(1.0)]),
//                                                                       startPoint: .center,
//                                                                       endPoint: .bottom)
//                                                    }
//                                                }
//                                            }
//                                            .tabViewStyle(PageTabViewStyle())
//                                            .frame(width: size.width, height: bannerStretchyHeight(minY))
//                                            .onReceive(timer, perform: { _ in
//                                                
//                                                if sliderIsAuto {
//                                                    withAnimation {
//                                                        selectionImageIndex = selectionImageIndex < detail.images.count ? selectionImageIndex + 1 : 0
//                                                    }
//                                                }
//                                            })
//                                            .overlay(alignment: .bottomTrailing) {
//                                                Button(action: {
//                                                    sliderIsAuto.toggle()
//                                                }, label: {
//                                                    Image(systemName: sliderIsAuto ? "pause.fill" : "play.fill")
//                                                        .sliderCounterAndPlayModifier
//                                                })
//                                                .offset(x: -10)
//                                                .opacity(titleOffset < collapsedNavBarHeight ? 0 : 1)
//                                            }
//                                        } else {
//                                            Image(user.banner)
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fill)
//                                                .frame(width: size.width, height: bannerStretchyHeight(minY))
//                                        }
//                                    }
//                                    
//                                    CustomBlurView()
//                                        .opacity(blurViewOpacity)
//                                    
//                                    // Title View
//                                    VStack(spacing: 5) {
//                                        Text(user.name)
//                                            .fontWeight(.bold)
//                                            .foregroundColor(.white)
//                                        Text("150 Tweets")
//                                            .foregroundColor(.white)
//                                    }
//                                    // To slide from bottom, add extra 60
//                                    .offset(y: 120)
//                                    .offset(y: getTitleOffset)
//                                    .opacity(titleOpacity)
//                                }
//                                .clipped()
//                                // Stretchy header
//                                .frame(height: bannerStretchyHeight(minY))
//                                .offset(y: bannerOffset(minY))
//                            )
//                        }
//                        .frame(height: headerHeight)
//                        .zIndex(1)
//                        
//                        VStack {
//                            
//                            // MARK: - Profile Image
//                            HStack {
//                                Image(user.image)
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: profileImageHeight, height: profileImageHeight, alignment: .top)
//                                    .clipShape(Circle())
//                                    .padding(8)
//                                    .background(bgColor)
//                                    .clipShape(Circle())
//                                    .offset(y: profileImageOffset)
//                                    .scaleEffect(profileImageScaleEffect)
//                                
//                                Spacer()
//                                
//                                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
//                                    Text("Edit Profile")
//                                        .foregroundColor(.blue)
//                                        .padding(.vertical, 10)
//                                        .padding(.horizontal)
//                                        .background(
//                                            Capsule()
//                                                .stroke(Color.blue, lineWidth: 1.5)
//                                        )
//                                })
//                            }
//                            .padding(.top, -25)
//                            .padding(.bottom, -10)
//                            
//                            // MARK: - Name and profile data
//                            VStack(alignment: .leading, spacing: 8) {
//                                Text(user.name)
//                                    .font(.system(size: 22, weight: .bold))
//                                    .foregroundColor(.primary)
//                                Text(user.handle)
//                                    .foregroundColor(.gray)
//                                Text(user.profileMessage)
//                                
//                                HStack(spacing: 5) {
//                                    Text("\(user.following)")
//                                        .foregroundColor(.primary)
//                                        .fontWeight(.semibold)
//                                    Text("Following")
//                                        .foregroundColor(.gray)
//                                    
//                                    Text("\(user.followers)")
//                                        .foregroundColor(.primary)
//                                        .fontWeight(.semibold)
//                                        .padding(.leading, 10)
//                                    
//                                    Text("Followers")
//                                        .foregroundColor(.gray)
//                                }
//                                .padding(.top, 8)
//                            }
//                            .overlay(alignment: .top) {
//                                GeometryReader { titleProxy -> Color in
//                                    
//                                    let minY = titleProxy.frame(in: .global).minY
//                                    
//                                    DispatchQueue.main.async {
//                                        self.titleOffset = minY
//                                    }
//                                    return Color.clear
//                                }
//                                .frame(width: 0, height: 0)
//                            }
//                            
//                            // MARK: - Custom Segmented View
//                            
//                            GeometryReader { pickerProxy in
//                                
//                                VStack(spacing: 0) {
//                                    
//                                    ScrollView(.horizontal, showsIndicators: false) {
//                                        
//                                        HStack(spacing: 0) {
//                                            TwitterTabButton(title: "Tweets", currentTab: $currentTab, animation: animation)
//                                            
//                                            TwitterTabButton(title: "Tweets & Likes", currentTab: $currentTab, animation: animation)
//                                            
//                                            TwitterTabButton(title: "Media", currentTab: $currentTab, animation: animation)
//                                            
//                                            TwitterTabButton(title: "Likes", currentTab: $currentTab, animation: animation)
//                                        }
//                                    }
//                                    Divider()
//                                }
//                                .padding(.top, 30)
//                                .background(bgColor)
//                                //.frame(width: size.width, height: pickerHeight)
//                                .offset(y: getPickerOffset(pickerProxy))
//                            }
//                            //.frame(height: pickerHeight)
//                            .zIndex(1)
//                            
//                            // MARK: - Tweets
//                            VStack(spacing: 18) {
//                                
//                                ForEach(user.tweets) { tweet in
//                                    TweetView(tweet: tweet, user: user)
//                                    
//                                    if tweet != user.tweets.last {
//                                        Divider()
//                                    }
//                                }
//                                Text(loremIpsum)
//                            }
//                            .padding(.top, 80)
//                            .zIndex(0)
//                        }
//                        .padding(.horizontal)
//                        // Movie view back once the header is greater than the collapsedNavBarHeight
//                        .zIndex(-offset > collapsedNavBarHeight ? 0 : 1)
//                    }
//                }
//                .ignoresSafeArea(.all, edges: .top)
//            }
//        }
//    }
//}
//
//#Preview {
//    TwitterProfileView()
//        .preferredColorScheme(.dark)
//}
//
//// MARK: - Helper functions to calculate offsets
//extension TwitterProfileView {
//    
//    private func bannerOffset(_ minY: CGFloat) -> CGFloat {
//        // if the minY (top of the image) is greater than zero
//        // ie the image is pulled down.
//        // -minY stretches the image when pulled down
//        if minY > 0 {
//            return -minY
//        } else {
//            // To stop the entire image from scrolling out of screen
//            if -minY < collapsedNavBarHeight {
//                return 0
//            }
//            return (-minY - collapsedNavBarHeight)
//        }
//        //minY > 0 ? -minY : 0
//    }
//    
//    private func bannerStretchyHeight(_ minY: CGFloat) -> CGFloat? {
//        // if the minY (top of the image) is greater than zero
//        // ie the image is pulled down.
//        minY > 0 ? headerHeight + minY : headerHeight
//    }
//    
//    // Profile image scrolling effect
//    private var profileImageOffset: CGFloat {
//        let progress = (-offset / collapsedNavBarHeight) * profileImageTopOffset
//        
//        let startingOffset = progress <= profileImageTopOffset ? progress : profileImageTopOffset
//        
//        if offset < 0 {
//            return startingOffset - profileImageTopOffset
//        }
//        return -profileImageTopOffset
//    }
//    
//    // Profile image shrinking effect
//    private var profileImageScaleEffect: CGFloat {
//        let progress = -offset / collapsedNavBarHeight
//        
//        let scale = 1.8 - (progress < 1.0 ? progress : 1)
//        
//        // since we are scaling the view to 0.8
//        // 1.8 - 1 will be 0.8
//        
//        return scale < 1 ? scale : 1
//    }
//    
//    // get the blur view opacity.
//    private var blurViewOpacity: Double {
//        // Where is 150 from ???
//        // arbitrary to determine when to show blur
//        let progress = -(offset + collapsedNavBarHeight) / headerHeight
//        
//        return Double(-offset > collapsedNavBarHeight ? progress : 0)
//    }
//    
//    // Get the segmented picker offset
////    private var getPickerOffset: CGFloat {
////        let stickyHeight = collapsedNavBarHeight + 10
////        
////        return pickerOffset < stickyHeight ? -pickerOffset + stickyHeight : 0
////    }
//    private func getPickerOffset(_ geometry: GeometryProxy) -> CGFloat {
//        let offset = geometry.frame(in: .global).minY
//        let stickyHeight = collapsedNavBarHeight + 10
//        
//        return offset < stickyHeight ? -offset + stickyHeight : 0
//    }
//    
//    // Get title Offset
//    private var getTitleOffset: CGFloat {
//        
//        // some amount of progress for slide effect
//        let progress = 20 / titleOffset
//        let offset = 60 * ( progress > 0 && progress <= 1 ? progress : 1)
//        
//        if titleOffset > 100 {
//            return 0
//        } else {
//            return -offset
//        }
//    }
//    
//    private var titleOpacity: Double {
//        titleOffset < 100 ? 1 : 0
//    }
//}
