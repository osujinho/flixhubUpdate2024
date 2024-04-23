//
//  PickerMenuBuilder.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/17/24.
//

import SwiftUI

struct PickerMenuBuilder<Selection: Pickable>: View {
    
    @Environment(\.screenSize) var screenSize
    @State private var verticalLocation: CGFloat = 0
    @State var showMenu: Bool = false
    var selection: PopoverContent<Selection>
    let options: [Selection]
    let placeholder: String
    let menuButtonHeight: CGFloat
    
    private var isScrollable: Bool { options.count > 5 }
    private let cornerRadius: CGFloat = 5
    private let itemButtonHeight: CGFloat = 40
    private let labelColor: Color = AppAssets.formListBg
    private let bgColor: Color = AppAssets.backgroundColor
    
    init(
        selection: PopoverContent<Selection>,
        options: [Selection],
        placeholder: String = "Select",
        menuButtonHeight: CGFloat = 40
    ) {
        self.selection = selection
        self.options = options
        self.placeholder = placeholder
        self.menuButtonHeight = menuButtonHeight
    }
    
    var body: some View {
        
        GeometryReader { geometry -> AnyView in
            let size = geometry.size
            
            DispatchQueue.main.async {
                self.verticalLocation = geometry.frame(in: .global).origin.y
            }
            
            return AnyView(
                HStack(spacing: 0) {
                    Text(formattedPlaceholder)
                        .foregroundStyle(placeholderColor)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: "chevron.down")
                        .font(.title3)
                        .foregroundStyle(.gray)
                        .rotationEffect(.degrees(showMenu ? -180 : 0))
                }
                .padding(.horizontal, 15)
                .frame(width: size.width, height: size.height)
                .background(labelColor)
                .onTapGestureModifier {
                    withAnimation(.snappy) {
                        showMenu.toggle()
                    }
                }
                .customPopover(isPresented: $showMenu, permittedArrowDirections: popoverAnchor) {
                    OptionsMenuContainer(width: size.width)
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .shadow(color: Color.primary.opacity(0.4), radius: 5, x: 0, y: 2 )
                .shadow(color: bgColor.opacity(0.3), radius: 20, x: 0, y: 10 )
                .frame(height: size.height)
            )
        }
        .frame(height: menuButtonHeight)
    }
    
    @ViewBuilder
    private func OptionsMenuContainer(width: CGFloat) -> some View {
            
        switch selection {
        case .single(let yearBinding) where yearBinding.wrappedValue is YearData:
                
            Picker("", selection: yearBinding) {
                ForEach(options, id: \.self) { option in
                    Text(option.description).tag(option as Selection?)
                        .font(.system(size: 15))
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: width, height: width * 0.8)
            
        default:
            Group {
                if isScrollable {
                    ScrollView(.vertical, showsIndicators: false) {
                        DropDownMenu()
                    }
                } else {
                    DropDownMenu()
                }
            }
            .frame(width: width, height: containerHeight)
        }
    }
    
    @ViewBuilder
    private func DropDownMenu() -> some View {
        VStack(spacing: 5) {
            ForEach(options, id: \.self) { option in
                
                let isSelected = checkIfSelected(option: option)
                
                HStack(spacing: 0) {
                    
                    if case .multiple(_) = selection {
                        Image(systemName: isSelected ? "square.inset.filled" : "square")
                            .font(.system(size: 15))
                            .foregroundStyle(isSelected ? AppAssets.reverseBackground : Color.gray)
                            .padding(.trailing, 20)
                    }
                    
                    Text(option.description)
                        .lineLimit(1)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 0)
                    
                    if case .single(_) = selection {
                        Image(systemName: "checkmark")
                            .font(.caption)
                            .opacity(isSelected ? 1 : 0)
                    }
                    
                }
                .foregroundStyle(isSelected ? AppAssets.reverseBackground : Color.gray)
                .frame(height: itemButtonHeight)
                .onTapGestureModifier {
                    toggleSelection(option: option)
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
    }
    
    private func checkIfSelected(option: Selection) -> Bool {
        switch selection {
        case .single(let selectedOption): return selectedOption.wrappedValue == option
            
        case .multiple(let options):
            return options.wrappedValue?.contains(where: { $0.id == option.id }) ?? false
        }
    }
    
    private func toggleSelection(option: Selection) {
        switch selection {
        case .single(let selectedOption):
            withAnimation(.snappy) {
                selectedOption.wrappedValue = option
                showMenu.toggle()
            }
            
        case .multiple(let optionsSet):
            if let existingIndex = optionsSet.wrappedValue?.firstIndex(where: { $0.id == option.id }) {
                optionsSet.wrappedValue?.remove(at: existingIndex)
            } else {
                optionsSet.wrappedValue?.insert(option)
            }
        }
    }
    
    var maxWidth: CGFloat {
        
        var wordWidth: CGFloat {
            switch selection {
            case .single:
                return options.map { $0.description.widthOfString(usingFont: UIFont.systemFont(ofSize: 15)) + 55 }.reduce(0, max)
            
            case .multiple:
                let maxOptionWidth = options.map { $0.description.widthOfString(usingFont: UIFont.systemFont(ofSize: 15)) + 35 }.reduce(0, max)
                
                return min(maxOptionWidth * 1.5, screenSize.width * 0.8)
            }
        }
        
        return max(wordWidth, screenSize.width * 0.5)
    }
    
    var containerHeight: CGFloat {
        let heightAndSpacing: CGFloat = itemButtonHeight + 5
        return min(CGFloat(options.count) * heightAndSpacing, heightAndSpacing * 5)
    }
    
    var popoverAnchor: UIPopoverArrowDirection {
        let bottomSpace = screenSize.height - (verticalLocation + (2 * itemButtonHeight))
        if containerHeight >= bottomSpace {
            return .down
        } else {
            return .up
        }
    }
    
    private var formattedPlaceholder: String {
        
        switch selection {
        case .single(let option): return option.wrappedValue?.description ?? placeholder
            
        case .multiple(let options):
            if let first = options.wrappedValue?.first?.description {
                let remainingCount = (options.wrappedValue?.count ?? 1) - 1
                return remainingCount > 0 ? "\(first) and \(remainingCount) more" : first
            }
            return placeholder
        }
    }
    
    private var placeholderColor: Color {
        switch selection {
        case .single(let option):
            return option.wrappedValue == nil ? .gray : .primary
        
        case .multiple(let options):
            return options.wrappedValue?.isEmpty ?? true ? .gray : .primary
        }
    }
}

#Preview {
    MenuPickerDemo()
}
