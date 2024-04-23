//
//  AttributtedString.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/7/24.
//

import SwiftUI

struct ImageLoaderDemo: View {
    
    @State var numberOfRows = 0
    @State private var linkImageAspectRatio: CGFloat?
    private let imageType: ImageType = .youtube

    var body: some View {
        NavigationView {
            list.navigationBarItems(trailing: addButton)
        }
    }
    
    private var list: some View {
        List(0..<numberOfRows, id: \.self) { _ in
            CustomAsyncImage(
                path: imageType.path,
                placeholder: {
                    imageType.placeholder
                },
                image: {
                    Image(uiImage: $0)
                        .resizable()
                }
            )
            .aspectRatio(contentMode: .fit)
            .frame(minHeight: 200, maxHeight: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private var addButton: some View {
        Button(action: { self.numberOfRows += 1 }) { Image(systemName: "plus") }
    }
}

#Preview {
    ImageLoaderDemo()
}

extension ImageType {
    var path: String {
        switch self {
        case .icon: return "/pbpMk2JmcoNnQwx5JGpXngfoWtp.jpg"
        case .poster: return "/zMpJY5CJKUufG9OTw0In4eAFqPX.jpg"
        case .backdrop: return "/8NCftAWfkETwrbf7QwEaDH1xpus.jpg"
        case .youtube: return "QfFasuouxQI"
        case .profile: return "/1Z0A8axunWqZrskGkfANv6W5qCl.jpg"
        case .link: return "https://www.arsenalpics.com/p/5/thierry-henry-arsenal-358175.jpg.webp"
        }
    }
}
