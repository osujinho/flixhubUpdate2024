//
//  ReviewsView.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 3/30/24.
//

import SwiftUI

struct ReviewsView: View {
    
    let comments: [CommentResponse]?
    private let emptyReviews: String = "No Reviews yet!"
    
    init(comments: [CommentResponse]?) {
        self.comments = comments?.sorted { (comment1, comment2) -> Bool in
            
            let timestamp1 = comment1.timestamp ?? comment1.updatedTimestamp
            let timestamp2 = comment2.timestamp ?? comment2.updatedTimestamp
            
            guard let date1 = timestamp1.flatMap(GlobalMethods.getDatefromISO),
                  let date2 = timestamp2.flatMap(GlobalMethods.getDatefromISO) else {
                return timestamp1 != nil
            }
            
            return date1 > date2
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            OptionalMethods.validOptionalBuilder(value: comments) { comments in
                ForEach(comments) { comment in
                    ReviewRow(comment: comment)
                    
                    if comment != comments.last {
                        Divider()
                    }
                }
            }
        }
        .onEmpty(for: !comments.isValid, with: emptyReviews)
    }
}

#Preview {
    ReviewsView(comments: mockComments)
}
