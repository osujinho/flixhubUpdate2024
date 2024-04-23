//
//  AppAssets.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 11/28/23.
//

import SwiftUI

struct AppAssets {
    
    static let gridColumns = [GridItem(.adaptive(minimum: 110, maximum: 130))]
    static let screen = UIScreen.main.bounds
    static let posterLabelColor = (Color(red: 3 / 255.0, green: 37 / 255.0, blue: 65 / 255.0))
    static let pickerColor: Color = Color("pickerColor")
    static let backgroundColor: Color = Color("background")
    static let tabColor: Color = Color("tabColor")
    static let reverseBackground: Color = Color("reverseBackground")
    static let posterColor: Color = Color("posterColor")
    static let backdropColor: Color = Color("backdropColor")
    static let formListBg: Color = Color("formListBg")
    static let formListBgDarkMode: Color = Color("formListBgDarkMode")
    
    struct DefaultImages {
        static let poster: Image = Image("defaultPoster")
        static let backdrop: Image = Image("genericBackdrop")
        static let profile: Image = Image("profile")
        static let youtube: Image = Image("youtubeThumbnail")
        static let icon: Image = Image(systemName: "tv")
        static let justWatch: Image = Image("justwatch")
    }
    
    struct ImageNames {
        static let genericBackdrop: String = "genericBackdrop"
        static let justWatch: String = "justwatch"
    }
    
    private init() { }
}
