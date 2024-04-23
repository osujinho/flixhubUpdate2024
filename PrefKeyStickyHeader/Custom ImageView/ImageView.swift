//
//  ImageView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/9/24.
//

import SwiftUI

struct ImageView: View {
    
    @EnvironmentObject var fullImageViewModel: FullImageViewModel
    @Binding var bgOpacity: Double
    
    @State private var imageOffset: CGSize = .zero
    @State private var imageScale: CGFloat = 0.0
    @State var currentScale: CGFloat = 1.0
    
    var body: some View {
        
        if let images = fullImageViewModel.images, !images.isEmpty {
            GeometryReader { proxy in
                
                if images.count > 1 {
                    TabView(selection: $fullImageViewModel.imageIndex) {
                        ForEach(0..<images.count, id: \.self) { index in
                            FormatImage(path: images[index], geometry: proxy)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .ignoresSafeArea(edges: .all)
                    .scaleEffect(imageScale)
                    .background(Color.clear)
                    .simultaneousGesture(DragGesture().onChanged({ value in
                        onDragChange(value: value, geometry: proxy)
                    }).onEnded({ (value) in
                        onDragEnd(value: value)
                    }))
                    
                } else {
                    FormatImage(path: images.compactMap { $0 }.first, geometry: proxy)
                    .scaleEffect(imageScale)
                    .simultaneousGesture(DragGesture().onChanged({ value in
                        onDragChange(value: value, geometry: proxy)
                    }).onEnded({ (value) in
                        onDragEnd(value: value)
                    }))
                }
            }
            .onAppear {
                withAnimation(.default) {
                    imageScale = 1.0
                }
            }
        }
        
    }
    
    func onDragChange(value: DragGesture.Value, geometry: GeometryProxy) {
        
        imageOffset = value.translation
        let size = geometry.size
        
        let halgHeight = size.height / 2
        let progress = imageOffset.height / halgHeight
        
        withAnimation(.default) {
            if currentScale <= 1 {
                bgOpacity = Double(1 - abs(progress))
                imageScale = 1 - abs(progress)
            }
        }
    }
    
    func onDragEnd(value: DragGesture.Value) {
        
        imageOffset = value.translation
        
        withAnimation(.easeInOut) {
            var translation = value.translation.height
            
            if translation < 0 {
                translation = -translation
            }
            
            if translation < 100 {
                if currentScale <= 1 {
                    imageOffset = .zero
                    imageScale = 1.0
                    bgOpacity = 1
                }
            } else {
                dismissImage()
            }
        }
    }
    
    func dismissImage() {
        fullImageViewModel.showImageView.toggle()
        imageScale = 0
        bgOpacity = 1.0
    }
    
    @ViewBuilder
    func FormatImage(path: String?, geometry: GeometryProxy) -> some View {
        
        ZoomableContainer(currentScale: $currentScale) {
            CustomAsyncImage(
                path: path,
                placeholder: {
                    fullImageViewModel.imageType.placeholder
                },
                image: {
                    Image(uiImage: $0)
                        .resizable()
                }
            )
            .aspectRatio(contentMode: .fit)
            .frame(width: geometry.size.width * 0.95)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(y: imageOffset.height)
        }
    }
}

#Preview {
    ActorsListView(actors: mockActors)
}
