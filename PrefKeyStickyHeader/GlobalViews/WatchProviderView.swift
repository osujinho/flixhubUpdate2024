//
//  WatchProviderView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 2/21/24.
//

import SwiftUI

struct WatchProviderView: View {
    
    @State private var screenWidth: CGFloat = 0
    let providers: WatchProviderData?
    private var subscription: [WatchProviderData.Provider] {
        ((providers?.ads ?? []) + (providers?.free ?? []) + (providers?.flatrate ?? [])).compactMap {$0}
    }
    private var link: URL? {
        providers?.link.flatMap(URL.init)
    }
    private let emptyProviders: String = "No watch providers available!"
    private let iconWidth: CGFloat = 80
    private let iconSpacing: CGFloat = 15
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ProvidersRow(providers: subscription, header: "stream", linkDestination: link)
            ProvidersRow(providers: providers?.rent, header: "rent", linkDestination: link)
            ProvidersRow(providers: providers?.buy, header: "buy", linkDestination: link)
            HStack(alignment: .firstTextBaseline) {
                Spacer()
                
                Text("Powered by ")
                    .font(.headline)
                
                CustomAsyncImage(
                    path: "justwatch",
                    placeholder: {
                        ImageType.icon.placeholder
                    },
                    image: {
                        Image(uiImage: $0)
                            .resizable()
                    }
                )
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                
                Spacer()
            }
            .padding(.vertical, 20)
        }
        .onEmpty(for: !providers.isValid, with: emptyProviders)
        .fixedSize(horizontal: false, vertical: true)
        .readSize { screenSize in
            self.screenWidth = screenSize.width
        }
    }
    
    @ViewBuilder
    func ProvidersRow(providers: [WatchProviderData.Provider]?, header: String, linkDestination: URL?) -> some View {
        
        OptionalMethods.validOptionalBuilder(value: providers) { providers in
            VerticalLabelContainerBuilder(header: header) {
                if isScrollable(total: providers.count) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(alignment: .bottom, spacing: iconSpacing) {
                            ForEach(providers, id: \.self) { provider in
                                providerIcon(provider: provider, linkDestination: linkDestination)
                            }
                        }
                        .padding(.leading)
                    }
                    .padding(.horizontal, -20)
                } else {
                    HStack(alignment: .bottom, spacing: iconSpacing) {
                        ForEach(providers, id: \.self) { provider in
                            providerIcon(provider: provider, linkDestination: linkDestination)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func providerIcon(provider: WatchProviderData.Provider, linkDestination: URL?) -> some View {
        
        OptionalMethods.conditionalOptionalBuilder(linkDestination) { link in
            Link(destination: link, label: {
                CustomAsyncImage(
                    path: provider.logoPath,
                    placeholder: {
                        ImageType.icon.placeholder
                    },
                    image: {
                        Image(uiImage: $0)
                            .resizable()
                    }
                )
                .aspectRatio(contentMode: .fill)
                .frame(width: iconWidth, height: iconWidth)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            })
        } else: {
            CustomAsyncImage(
                path: provider.logoPath,
                placeholder: {
                    ImageType.icon.placeholder
                },
                image: {
                    Image(uiImage: $0)
                        .resizable()
                }
            )
            .aspectRatio(contentMode: .fill)
            .frame(width: iconWidth, height: iconWidth)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
    
    private func isScrollable(total: Int) -> Bool {
        let totalWidth = CGFloat(total) * (iconWidth + iconSpacing)
        return totalWidth > (screenWidth)
    }
}

#Preview {
    MovieDetailView(movieId: 508442)
}
