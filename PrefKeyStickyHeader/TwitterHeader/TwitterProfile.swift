//
//  TwitterProfile.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 12/8/23.
//

import Foundation

struct TwitterProfile: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    var handle: String
    var followers: Int
    var following: Int
    var profileMessage: String
    var image: String
    var banner: String
    var tweets: [Tweet]
}

struct Tweet: Identifiable, Hashable {
    var id = UUID().uuidString
    var tweetText: String
    var tweetImage: String?
}

let jasmine: TwitterProfile = .init(
    name: "Jasmine",
    handle: "@poutyjas",
    followers: 826,
    following: 147,
    profileMessage: "\"The mind is everything. What you think you become\" - Buddha",
    image: "jasmine",
    banner: "banner",
    tweets: [.init(tweetText: "Modeling cozy winter gear ❄️🥳🥳", tweetImage: "jasmineTweet1"),
             .init(tweetText: "hey u there!! yea u 🥰 i hope u have a poggers day", tweetImage: "pogger"),
             .init(tweetText: "happy new year 💜", tweetImage: "newYear"),
             .init(tweetText: "would u come up the zoo with me 🐴🐎🐒", tweetImage: "zoo"),
             .init(tweetText: "Solana has the hottest stepbros in web3", tweetImage: "stepbro"),
             .init(tweetText: "earth angel 👼", tweetImage: "earth"),
             .init(tweetText: "gm to everyone who says it back 😋", tweetImage: "morning")
            ]
)
