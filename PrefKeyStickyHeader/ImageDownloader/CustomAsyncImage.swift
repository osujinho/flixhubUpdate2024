//
//  CustomAsyncImage.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/7/24.
//

import SwiftUI

struct CustomAsyncImage<Placeholder : View>: View {
    
    @Environment(\.colorScheme) var scheme
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let image: (UIImage) -> Image
    
    var fontColor: Color {
        scheme == .dark ? .black : .white
    }
    
    init(
        path: String?,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
    ) {
        
        self.placeholder = placeholder()
        self.image = image
        self._loader = StateObject(wrappedValue: ImageLoader(
            path: path,
            cache: ImageCache()
        ))
    }
    
    var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    
    private var content: some View {
        Group {
            if loader.isLoading {
                ZStack {
                    Rectangle()
                        .fill(AppAssets.reverseBackground)
                    ImageLoadingView(color: fontColor)
                }
            } else {
                if let uiImage = loader.image {
                    image(uiImage)
                } else {
                    placeholder
                }
            }
        }
    }
}

#Preview {
    let imageType: ImageType = .poster
    
    return CustomAsyncImage(path: "/zMpJY5CJKUufG9OTw0In4eAFqPX.jpg") {
        imageType.placeholder
    }
    .aspectRatio(imageType.aspectRatio, contentMode: .fit)
}
