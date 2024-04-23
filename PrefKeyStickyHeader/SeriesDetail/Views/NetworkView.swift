//
//  NetworkView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/22/24.
//

import SwiftUI

struct NetworkView: View {
    
    let networks: [SeriesNetworkResponse]?
    @State private var totalHeight: CGFloat = 100
    private let iconSpacing: CGFloat = 20
    private let iconWidth: CGFloat = 40
    
    var body: some View {
        VerticalLabelContainerBuilder(header: header) {
            GeometryReader { geometry in
                Group {
                    OptionalMethods.conditionalOptionalBuilder(networks) { networks in
                        if isScrollable(total: networks.count, geometry) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(alignment: .bottom, spacing: iconSpacing) {
                                    ForEach(networks, id: \.self) { network in
                                        NetworkIcon(network: network)
                                    }
                                }
                                .padding(.leading)
                            }
                            .padding(.horizontal, -20)
                        } else {
                            HStack(alignment: .bottom, spacing: iconSpacing) {
                                ForEach(networks, id: \.self) { network in
                                    NetworkIcon(network: network)
                                }
                            }
                        }
                    } else: {
                        Text(GlobalValues.defaultWrappedString)
                    }
                }
                .geometryHeightReader(height: $totalHeight)
            }
            .frame(height: totalHeight)
        }
    }
    
    @ViewBuilder
    private func NetworkIcon(network: SeriesNetworkResponse) -> some View {
        
        VStack(spacing: 5) {
            CustomAsyncImage(
                path: network.logo,
                placeholder: {
                    ImageType.icon.placeholder
                },
                image: {
                    Image(uiImage: $0)
                        .resizable()
                }
            )
            .aspectRatio(contentMode: .fit)
            .frame(width: iconWidth)
            
            if !network.logo.isValid {
                OptionalMethods.validOptionalBuilder(value: network.name) { networkName in
                    Text(networkName)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private func isScrollable(total: Int, _ geometry: GeometryProxy) -> Bool {
        let totalWidth = CGFloat(total) * (iconWidth + iconSpacing)
        return totalWidth > (geometry.size.width)
    }
    
    private var header: String {
        return networks?.count ?? 0 > 1 ? "Networks" : "Network"
    }
}

#Preview {
    
    let mockNetwork: [SeriesNetworkResponse] = [.init(id: 290, logo: "/fqsd09CrijoGu6qfoNIdgUQmVGO.png", name: "TF1")]
    
    return NetworkView(networks: mockNetwork)
}
