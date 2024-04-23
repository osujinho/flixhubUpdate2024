//
//  ReviewRow.swift
//  PrefKeyStickyHeader
//
//  Created by Michael Osuji on 4/1/24.
//

import SwiftUI

struct ReviewRow: View {
    
    @State private var showMore = false
    @State private var screenWidth: CGFloat = 0
    @State private var attributeComment: AttributedString = ""
    
    let comment: CommentResponse
    let imageWidth: CGFloat = 40
    private let linelimit: Int = 4
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            CustomAsyncImage(
                path: comment.poster,
                placeholder: {
                    ImageType.profile.placeholder
                },
                image: {
                    Image(uiImage: $0)
                        .resizable()
                }
            )
            .aspectRatio(contentMode: .fill)
            .frame(width: imageWidth, height: imageWidth, alignment: .center)
            .clipShape(Circle())
            .shadow(color: Color.primary.opacity(0.4), radius: 5, x: 0, y: 2 )
            .shadow(color: AppAssets.backgroundColor.opacity(0.3), radius: 20, x: 0, y: 10 )
            
            // MARK: - Name and Comment
            VStack(alignment: .leading, spacing: 10) {
                
                // Name and Username
                VStack(alignment: .leading, spacing: 5){
                    HStack(spacing: 3) {
                        OptionalMethods.validOptionalBuilder(value: comment.name) { name in
                            Text(name.removeExtraSpaces)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .fixedSize()
                        }
                        
                        OptionalMethods.validOptionalBuilder(value: comment.authorDetail?.username) { username in
                            Text("@" + username.lowercased())
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    OptionalMethods.validOptionalBuilder(value: comment.updatedTimestamp ?? comment.timestamp) { timestamp in
                        
                        Text(GlobalMethods.formatTimestamp(timestamp))
                    }
                }
                
                // Comment Section
                VStack(alignment: .leading) {
                    
                    OptionalMethods.conditionalOptionalBuilder(attributeComment) { comment in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(comment)
                                .lineLimit(showMore ? nil : linelimit)
                                .readSize { screenSize in
                                    self.screenWidth = screenSize.width
                                }
                            
                            if isLonger {
                                Button(action: {
                                    withAnimation(.linear) {
                                        showMore.toggle()
                                    }
                                }, label: {
                                    Text(showMore ? "Show less..." : "Show more...")
                                        .fontWeight(.bold)
                                        .foregroundColor(showMore ? Color.red : Color.blue)
                                })
                                
                            }
                        }
                    } else: {
                        Text(GlobalValues.defaultWrappedString)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.primary.opacity(0.2))
                )
            }
            .font(.system(size: 13))
        }
        .padding(.vertical, 10)
        .onAppear {
            if let commentText = comment.content {
                DispatchQueue.main.async {
                    self.attributeComment = commentText.htmlToAttributedString
                }
            }
        }
    }
    
    private var isLonger: Bool {
        if let comment = comment.content {
            let commentWidth = comment.widthOfString(usingFont: UIFont.systemFont(ofSize: 13))
            return (commentWidth / screenWidth) > CGFloat(linelimit)
        }
        return false
    }
}

#Preview {
    ZStack {
        AppAssets.backgroundColor
        
        ReviewRow(comment: mockComment5)
    }
}
