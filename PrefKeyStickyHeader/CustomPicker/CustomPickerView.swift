//
//  CustomPickerView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 11/30/23.
//

import SwiftUI

struct CustomPickerView<Enum: EnumPickable>: View {
    
    @Binding private var selection: Enum?
    let screenWidth: CGFloat
    let fontSize: CGFloat
    let forSearchScope: Bool
    @Namespace private var animation
    
    private let animationId: String = "picker"
    private let horizontalPadding: CGFloat = 12
    private var selectionColor: Color {
        forSearchScope ? Color.blue : Color.blue.opacity(0.7)
    }
    
    init(selection: Binding<Enum?>, screenWidth: CGFloat, fontSize: CGFloat = 13, forSearchScope: Bool = false) {
        self._selection = selection
        self.screenWidth = screenWidth
        self.fontSize = fontSize
        self.forSearchScope = forSearchScope
    }
    
    var body: some View {
        VStack {
            if isScrollable {
                ScrollView(.horizontal, showsIndicators: false) {
                    pickerView
                }
            } else {
                pickerView
            }
        }
    }
    
    func getWidth(_ description: String) -> CGFloat {
        let width: CGFloat = description.widthOfString(usingFont: UIFont.systemFont(ofSize: fontSize))
        return width * 1.2
    }
    
    private var isScrollable: Bool {
        let totalWidth = Array(Enum.allCases).map { getWidth($0.description) + horizontalPadding }.reduce(0, +)
        return totalWidth > screenWidth
    }
}

extension CustomPickerView {
    
    private var pickerView: some View {
        HStack(alignment: .bottom) {
            
            let values = Array(Enum.allCases)
            
            ForEach(values) { value in
                if forSearchScope {
                    searchScopeItemView(value: value)
                        .padding(.top, 10)
                        .tag(value as Enum?)
                } else {
                    pickerItemView(value: value)
                        .tag(value as Enum?)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func pickerItemView(value: Enum) -> some View {
        
        Text(value.description).tag(value)
            .font(.system(size: fontSize))
            .foregroundColor(self.selection == value ? selectionColor : .gray)
            .padding(EdgeInsets(
                top: 14,
                leading: (horizontalPadding / 2),
                bottom: 14,
                trailing: (horizontalPadding / 2)
            ))
            .overlay(
                ZStack {
                    CustomShape()
                        .fill(Color.clear)
                        .frame(width: getWidth(value.description), height: 3)
                    
                    if selection == value {
                        
                        CustomShape()
                            .fill(selectionColor)
                            .frame(width: getWidth(value.description), height: 3)
                            .matchedGeometryEffect(id: animationId, in: animation)
                    }
                }
                ,alignment: .bottom
            )
            .onTapGestureModifier {
                withAnimation {
                    self.selection = value
                }
            }
    }
    
    private func searchScopeItemView(value: Enum) -> some View {
        
        ZStack {
            let capsuleHeight: CGFloat = 35
            
            if selection == value {
                Capsule()
                    .foregroundStyle(selectionColor)
                    .frame(height: capsuleHeight)
                    .matchedGeometryEffect(id: animationId, in: animation)
                Text(value.description).tag(value)
                    .font(.system(size: fontSize))
                    .foregroundStyle(.white)
                    .padding(.horizontal, horizontalPadding / 2)
                    .padding(.vertical, 8)
                    .clipShape(Capsule())
            }
            else {
                Capsule()
                    .foregroundStyle(.clear)
                    .frame(height: capsuleHeight)
                Text(value.description).tag(value)
                    .font(.system(size: fontSize))
                    .foregroundStyle(.primary)
                    .padding(.horizontal, horizontalPadding / 2)
                    .padding(.vertical, 5)
                    .clipShape(Capsule())
            }
        }
        .onTapGestureModifier {
            withAnimation {
                self.selection = value
            }
        }
    }
}

#Preview {
    SearchView()
    //FilterFormView()
}
