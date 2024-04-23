//
//  FullImageViewModel.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/28/24.
//

import Foundation

class FullImageViewModel: ObservableObject {
    @Published var showImageView: Bool = false
    @Published var imageType: ImageType = .poster
    @Published var images: [String?]?
    @Published var imageIndex: Int = 0
    
    func displayImage(_ imagePath: String?, imageType: ImageType) {
        images = [imagePath]
        self.imageType = imageType
        self.showImageView.toggle()
    }
    
    func displaySlideView(_ images: [String?]?, image: String?, imageType: ImageType) {
        self.images = images
        
        if let image = image, let images = images {
            if let index = images.firstIndex(where: { $0 == image }) {
                self.imageIndex = index
            }
        }
        
        self.showImageView.toggle()
    }
}
