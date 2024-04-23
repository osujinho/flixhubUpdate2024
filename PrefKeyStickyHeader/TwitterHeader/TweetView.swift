//
//  TweetView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 12/8/23.
//

import SwiftUI

struct TweetView: View {
    
    let tweet: Tweet
    let user: TwitterProfile
    
    private var tweetProfileHeight: CGFloat = 60
    
    init(tweet: Tweet, user: TwitterProfile) {
        self.tweet = tweet
        self.user = user
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            
            Image(user.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: tweetProfileHeight, height: tweetProfileHeight, alignment: .top)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 10) {
                (
                    Text(user.name + "  ")
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    +
                    
                    Text(user.handle)
                        .foregroundColor(.gray)
                )
                Text(tweet.tweetText)
                    .frame(maxHeight: 100, alignment: .top)
                
                if let image = tweet.tweetImage {
                    GeometryReader { proxy in
                        let imageWidth: CGFloat = proxy.frame(in: .global).width
                        let imageHeight: CGFloat = 200
                        
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageWidth, height: imageHeight)
                            .cornerRadius(15)
                    }
                    .frame(height: 200)
                }
            }
        }
    }
}
