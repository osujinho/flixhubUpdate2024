//
//  StreamingServiceOption.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/5/24.
//

import Foundation

enum StreamingServiceOption: Int, IntIdentifiable {
    case netflix = 8
    case disney = 337
    case prime = 9
    case apple = 350
    case max = 1899
    case hulu = 15
    case paramount = 531
    case peacock = 386
    case youtube = 192
    
    var id: Int { self.rawValue }
    
    var description: String {
        switch self {
        case .netflix: return "Netflix"
        
        case .disney: return "Disney+"
        
        case .prime: return "Prime Video"
        
        case .apple: return "Apple TV+"
        
        case .max: return "Max"
        
        case .hulu: return "Hulu"
        
        case .paramount: return "Paramount+"
            
        case .peacock: return "Peacock"
            
        case .youtube: return "YouTube"
        }
    }
}
