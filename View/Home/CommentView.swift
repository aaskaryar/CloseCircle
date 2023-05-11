//
//  CommentView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 6/1/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct CommentView: View {
    var commentId : String
    var comment: CommentModel
    @EnvironmentObject var newCommentData : NewCommentModel
    @Binding var commentIdToDelete : AlertInfo?
    @State var delete : Bool = false
    let dateFormatter = DateFormatter()
    
    var body: some View {
        
        VStack{
            
            HStack(alignment: .top){
                
                EquatableWebImage(url: comment.profilepicurl ?? "", size: 50, shape: Circle())
                    .equatable()
                    .padding(.trailing, 10)
                
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
                        
                        if comment.uid == auth.currentUser!.uid{
                            
                            Button(action: {
                                commentIdToDelete = AlertInfo(Title: "", Message: commentId)
                            }) {
                                Image(systemName: "trash.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.red)
                            }
                        }
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

