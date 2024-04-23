//
//  FriendCardRowView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 12/7/23.
//

import SwiftUI

struct FriendCardRowView: View {
    
    let friend: Friend
    let imageHeight: CGFloat = 60
    
    var body: some View {
        
        HStack(spacing: 15) {
            Image(friend.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: imageHeight, height: imageHeight, alignment: .top)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 8) {
                Text(friend.name)
                    .fontWeight(.bold)
                
                Text(friend.detail)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Buttons
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image(systemName: "message.fill")
                    .foregroundColor(.yellow)
                    .padding()
                    .background(Color.yellow.opacity(0.2))
                    .clipShape(Circle())
            })
            .padding(.trailing, -5)
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image(systemName: "phone.fill")
                    .foregroundColor(.yellow)
                    .padding()
                    .background(Color.yellow.opacity(0.2))
                    .clipShape(Circle())
            })
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
