//
//  HomeHeader.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 12/6/23.
//

import Foundation

struct Friend: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    var detail: String
    var image: String
}

var friends: [Friend] = [
    .init(name: "Ariana", detail: "1.5 Miles Away", image: "ariana"),
    .init(name: "Dani", detail: "2 Miles Away", image: "dani"),
    .init(name: "Elena", detail: "1 Miles Away", image: "elena"),
    .init(name: "Gia", detail: "2.2 Miles Away", image: "gia"),
    .init(name: "Gianna", detail: "0.6 Miles Away", image: "gianna"),
    .init(name: "Honey", detail: "0.2 Miles Away", image: "honey"),
    .init(name: "Jasmine", detail: "0.1 Miles Away", image: "jasmine"),
    .init(name: "Jaye", detail: "0.4 Miles Away", image: "jaye"),
    .init(name: "Kendra", detail: "1.3 Miles Away", image: "kendra"),
    .init(name: "Kenna", detail: "0.2 Miles Away", image: "kenna"),
    .init(name: "Lily", detail: "0.3 Miles Away", image: "lily"),
    .init(name: "Mia", detail: "3 Miles Away", image: "mia"),
    .init(name: "Remy", detail: "3.5 Miles Away", image: "remy"),
    .init(name: "Riley", detail: "4 Miles Away", image: "riley"),
    .init(name: "Shyla", detail: "4.3 Miles Away", image: "shyla"),
    .init(name: "Scarlit", detail: "1.7 Miles Away", image: "scarlit")
]
