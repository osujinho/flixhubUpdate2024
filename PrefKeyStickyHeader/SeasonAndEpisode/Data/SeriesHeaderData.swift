//
//  SeriesHeaderData.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/19/24.
//

import Foundation

struct SeriesHeaderData {
    var seriesId: Int
    var seriesName: String?
    var seriesMpaRating: String?
    var seriesBackdrop: String?
    
    init(seriesId: Int, seriesName: String?, seriesMpaRating: String?, seriesBackdrop: String?) {
        self.seriesId = seriesId
        self.seriesName = seriesName
        self.seriesMpaRating = seriesMpaRating
        self.seriesBackdrop = seriesBackdrop
    }
}
