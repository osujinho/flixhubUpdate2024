//
//  SearchBarWithScope.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/11/24.
//

import SwiftUI

struct SearchBarWithScope<Enum: EnumPickable>: View {
    
    @Binding var scopeOptions: Enum?
    @Binding var searchText: String
    @Binding var isEditing: Bool
    var namespace: Namespace.ID
    var matchedGeometryId: String
    @FocusState private var focusedField: Bool
    @State private var showCancelButton = false
    let screenWidth: CGFloat
    let cancelAction: () -> Void
    private let animationDuration: TimeInterval = 0.5
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Search Bar
            HStack {
                TextField("Search...", text: $searchText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color.primary.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .focused($focusedField)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                     
                            if isEditing {
                                Button(action: {
                                    self.searchText = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                                .opacity(showCancelButton ? 1 : 0)
                            }
                        }
                    )
                    .onTapGestureModifier {
                        withAnimation(.linear(duration: animationDuration)) {
                            self.isEditing = true
                        }
                    }
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .matchedGeometryEffect(id: matchedGeometryId, in: namespace)
                
                if isEditing {
                    Button(action: {
                        self.focusedField = false
                        self.searchText = ""
                        cancelAction()
                        withAnimation(.linear(duration: animationDuration)) {
                            self.isEditing = false
                            showCancelButton = false
                        }
                    }) {
                        Text("Cancel")
                    }
                    .opacity(showCancelButton ? 1 : 0)
                }
            }
            
            // MARK: - Scope
            if isEditing {
                CustomPickerView(selection: $scopeOptions, screenWidth: screenWidth, forSearchScope: true)
                    .opacity(showCancelButton ? 1 : 0)
            }
        }
        .padding(.vertical, 10)
        .onAppear {
            if isEditing {
                if searchText.isEmpty {
                    self.focusedField = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        showCancelButton = true
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
