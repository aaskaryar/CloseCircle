//
//  ProfileCommentView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/5/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileCommentView: View {
    
    var commentId : String
    var comment: CommentModel
    @EnvironmentObject var newCommentData : NewCommentModel
    @State var delete : Bool = false
    let dateFormatter = DateFormatter()
    
    var body: some View {
        
        VStack{
            
            HStack(alignment: .top){
                
                EquatableWebImage(url: comment.profilepicurl ?? "", size: 50, shape: Circle())
                    .equatable()
                    .padding(.trailing, 10)
                
//                let scale = UIScreen.main.scale // Will be 2.0 on 6/7/8 and 3.0 on 6+/7+/8+ or later
//                let thumbnailSize = CGSize(width: 50 * scale, height: 50 * scale) // Thumbnail w
//
//                WebImage(url: URL(string: comment.profilepicurl ?? Constants.DEFAULT_WEBPICTURE), context: [.imageThumbnailPixelSize : thumbnailSize])
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 50, height: 50)
//                    .clipShape(Circle())
//                    .padding(.trailing, 10)
//
                VStack(alignment:.leading){
                    
                    HStack{
                        Text(comment.profileusername ?? "SomeBody")
                            .bold()
                            .font(Font.custom("DM Sans", size: 16))
                        
                        Text("~")
                            .font(Font.custom("DM Sans", size: 10))
                            .foregroundColor(.gray)
                        
                        Text(Date().offset(from: comment.timePosted))
                            .font(Font.custom("DM Sans", size: 10))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                    }
                    //.padding(.bottom, 5)
                    
                    Text(comment.text)
                        .font(Font.custom("DM Sans", size: 14))
                   
                }
                
                
                
            }
            
            HStack{
                Button(action: {
                    
                    if commentId == newCommentData.commentFocusedId{
                        newCommentData.commentFocusedId = nil
                    }else{
                        newCommentData.commentFocusedId = commentId
                    }
                    
                })
                {
                    Image(systemName: "arrowshape.turn.up.right.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 15)
                        .foregroundColor(
                            newCommentData.commentFocusedId == commentId ? Constants.ShadeTeal : Constants.ShadeGray
                        )
                }
                .padding(.leading, 60)
                
                Spacer()
            }
            
        }
        .padding(.leading,15)
        
    }
}
//
//struct ProfileCommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileCommentView()
//    }
//}
