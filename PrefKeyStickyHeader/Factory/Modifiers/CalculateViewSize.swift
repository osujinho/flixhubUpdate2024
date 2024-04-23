//
//  CalculateViewSize.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 1/16/24.
//
#warning("Not for Flixhub. Not used!")
import SwiftUI

/**
 
    How to use
 
     struct SomeView: View {
         
         @State var size: CGSize = .zero
         
         var body: some View {
             VStack {
                 Text("text width: \(size.width)")
                 Text("text height: \(size.height)")
                 
                 Text("hello")
                     .saveSize(in: $size)
             }
             
         }
     }
 
 */

struct SizeCalculator: ViewModifier {
    
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear // we just want the reader to get triggered, so let's use an empty color
                        .onAppear {
                            size = proxy.size
                        }
                }
            )
    }
}

extension View {
    func saveSize(in size: Binding<CGSize>) -> some View {
        modifier(SizeCalculator(size: size))
    }
}
