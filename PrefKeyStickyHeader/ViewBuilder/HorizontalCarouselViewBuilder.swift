//
//  HorizontalCarouselViewBuilder.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/2/24.
//

import SwiftUI

struct HorizontalCarouselViewBuilder<Data, Destination, Content>: View where Data: ForEachCollection, Destination: View, Content: View, Data.Element: Hashable {
    
    @State private var screenWidth: CGFloat = 0
    let label: String
    let itemWidth: CGFloat?
    let data: Data?
    let destination: ((Data) -> Destination)?
    let content: (Data.Element) -> Content
    let action: (() -> Void)?
    
    private let horizontalSpacing: CGFloat = 20
    private var isScrollable: Bool {
        if let itemWidth = itemWidth, let data = data, !data.isEmpty {
            return ((itemWidth + horizontalSpacing) * CGFloat(data.count)) > screenWidth
        }
        return false
    }
    
    private init(
        label: String,
        itemWidth: CGFloat?,
        data: Data?,
        action: (() -> Void)?,
        destination: ((Data) -> Destination)?,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.label = label
        self.itemWidth = itemWidth
        self.data = data
        self.destination = destination
        self.action = action
        self.content = content
    }
    
    var body: some View {
        OptionalMethods.validOptionalBuilder(value: data) { data in
            
            VStack(alignment: .leading, spacing: 10) {
                
                // Top Title and Navigation
                HStack {
                    VerticalHeaderView(header: label)
                    
                    Spacer()
                    
                    if isScrollable {
                        
                        if let destination = destination {
                            NavigateToView {
                                destination(data)
                            } label: {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 10))
                            }
                        } else if let action = action {
                            Button {
                                action()
                            } label: {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 10))
                            }
                        }
                    }
                }
                
                Group {
                    if isScrollable {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(alignment: .top, spacing: horizontalSpacing) {
                                ForEach(data, id: \.self) { dataElement in
                                    content(dataElement)
                                }
                            }
                            .padding()
                        }
                        .padding(.horizontal, -20)
                    } else {
                        HStack(alignment: .top, spacing: horizontalSpacing) {
                            ForEach(data, id: \.self) { dataElement in
                                content(dataElement)
                            }
                        }
                    }
                }
                .readSize { screenSize in
                    self.screenWidth = screenSize.width
                }
            }
        }
    }
}

extension HorizontalCarouselViewBuilder {
    
    // To Use Action
    init(
        label: String,
        itemWidth: CGFloat?,
        data: Data?,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) where Destination == EmptyView {
        self.init(
            label: label,
            itemWidth: itemWidth,
            data: data,
            action: action,
            destination: nil,
            content: content
        )
    }
    
    // To use Destination
    init(
        label: String,
        itemWidth: CGFloat?,
        data: Data?,
        action: (() -> Void)? = nil,
        @ViewBuilder destination: @escaping (Data) -> Destination,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.label = label
        self.itemWidth = itemWidth
        self.data = data
        self.destination = destination
        self.action = action
        self.content = content
    }
    
    // No Action Or Destination
    init(
        label: String,
        itemWidth: CGFloat?,
        data: Data?,
        action: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) where Destination == EmptyView {
        self.init(
            label: label,
            itemWidth: itemWidth,
            data: data,
            action: action,
            destination: nil,
            content: content
        )
    }
}
