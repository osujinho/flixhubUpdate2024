//
//  HtmlString.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/1/24.
//

import SwiftUI

extension String {
    
    var htmlToAttributedString: AttributedString {
        let defaultString = AttributedString(self)
        guard let data = self.data(using: .utf16) else { return defaultString }
        
        do {
            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return AttributedString(attributedString)
        } catch {
            return defaultString
        }
    }
}
