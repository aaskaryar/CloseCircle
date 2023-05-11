//
//  SearchPostDetail.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/21/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchPostDetail: View {
    
    @StateObject var commentData : CommentViewModel
    @EnvironmentObject var newCommentData : NewCommentModel
    @State var clicked : Bool = false
    @State var alert : Bool = false
    @State var scrollHeight = CGFloat.zero
    @State var contentHeight = CGFloat.zero
    @State var commentText : String = ""
    @State var delete : Bool = false
    @State var videoToPlay : videoPlayInfo?
    @FocusState private var focus: Bool
    //@Binding var postToDelete : CardModel?
    var card: CardModel
    @Environment(\.dismiss) var dismiss
    var spaceName = "PostDetail"
    
    
    init(card: CardModel){
        self.card = card
        _commentData = StateObject(wrappedValue: CommentViewModel(postId: card.id, postTime: card.timePosted))
        
    }
    
    var body: some View {
        
        VStack(alignment: .center){
            
            HStack{
                
                Text("Post Detail")
                    .font(Font.custom("DMSans-Bold", size: 26))
                
                Spacer()
                
                Button(action: {dismiss()}) {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .foregroundColor(.black)
                }
            }
            .padding(.top, 5)
            .frame(width: Constants.width - 40)
            
            
            RefreshableScrollView(id: spaceName) {
                commentData.getMoreComments(size: 10)
            } onPullDown: {
                commentData.getMoreComments(size: 10)
            } content:
            {
                HStack{
                    
                    EquatableWebImage(url: card.profileImage, size: 30, shape: Circle())
                        .equatable()
                    
        //                Image("outdoors")
        //                    .resizable()
        //                    .frame(width: 30, height:30)
        //                    .clipShape(Circle())
        //                    .aspectRatio(contentMode: .fit)
        //                    //.padding(.leading,10)
                    
                    VStack(alignment:.leading){
                        
                        Text(card.username)
                            .font(Font.custom("DM Sans", size: 15))
                        
                        DateShower(date: card.timePosted, size: 10)
                    }
                    
                    Spacer()

                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.08)
                .padding(.bottom, 5)
                
                EquatableWebImage(url: card.image, size: UIScreen.main.bounds.width * 0.84, shape: RoundedRectangle(cornerRadius: 20))
                    .equatable()
                    .onTapGesture(){
                        clicked.toggle()
                    }
                    .overlay(
                        VStack{
                            HStack{
                                Button {
                                    videoToPlay = videoPlayInfo(uid: card.uid, pid: card.id)
                                } label: {
                                    
                                    Image(systemName: "play.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, alignment: .center)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .disabled(!card.isVideo)
                        .opacity(card.isVideo ? 1 : 0)
                    )
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.08)
                    
               
                        
                
                HStack{
                    
                    Text(card.description)
                        .font(Font.custom("DMSans-Bold", size: 20))
                        .padding(.vertical)
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.08)
                    
                    Spacer()
                }
                
                Divider()
                
                ForEach(commentData.comments!.keys.sorted(by: <), id: \.self) { id in
                    
                    let comment = commentData.comments![id]
                    
                    ProfileCommentView(commentId: id, comment: comment!)
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                    
                }
            }

            
//            GeometryReader{ scrollProxy in
//
//                ScrollView(showsIndicators: false)  {
//
//                    PullToRefresh(coordinateSpaceName: spaceName) {
//
//                        //commentData.refreshComment()
//
//                        if scrollHeight > contentHeight{
//                            commentData.getMoreComments(size: 10)
//                            print("out")
//                        }
//
//                    }
//
//                    VStack(alignment: .center){
//
//                        HStack{
//
//                            EquatableWebImage(url: card.profileImage, size: 30, shape: Circle())
//                                .equatable()
//
//                //                Image("outdoors")
//                //                    .resizable()
//                //                    .frame(width: 30, height:30)
//                //                    .clipShape(Circle())
//                //                    .aspectRatio(contentMode: .fit)
//                //                    //.padding(.leading,10)
//
//                            VStack(alignment:.leading){
//
//                                Text(card.username)
//                                    .font(Font.custom("DM Sans", size: 15))
//
//                                DateShower(date: card.timePosted, size: 10)
//                            }
//
//                            Spacer()
//
//                        }
//                        .padding(.horizontal, UIScreen.main.bounds.width * 0.08)
//                        .padding(.bottom, 5)
//
//                        EquatableWebImage(url: card.image, size: UIScreen.main.bounds.width * 0.84, shape: RoundedRectangle(cornerRadius: 20))
//                            .equatable()
//                            .onTapGesture(){
//                                clicked.toggle()
//                            }
//                            .overlay(
//                                VStack{
//                                    HStack{
//                                        Button {
//                                            videoToPlay = videoPlayInfo(uid: card.uid, pid: card.id)
//                                        } label: {
//
//                                            Image(systemName: "play.circle.fill")
//                                                .resizable()
//                                                .scaledToFit()
//                                                .frame(width: 40, alignment: .center)
//                                                .foregroundColor(.white)
//                                        }
//                                    }
//                                }
//                                .disabled(!card.isVideo)
//                                .opacity(card.isVideo ? 1 : 0)
//                            )
//                            .padding(.horizontal, UIScreen.main.bounds.width * 0.08)
//
//
//
//
//                        HStack{
//
//                            Text(card.description)
//                                .font(Font.custom("DMSans-Bold", size: 20))
//                                .padding(.vertical)
//                                .padding(.horizontal, UIScreen.main.bounds.width * 0.08)
//
//                            Spacer()
//                        }
//
//                        Divider()
//
//                        ForEach(commentData.comments!.keys.sorted(by: <), id: \.self) { id in
//
//                            let comment = commentData.comments![id]
//
//                            ProfileCommentView(commentId: id, comment: comment!)
//                                .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
//
//                        }
//                    }
//                    .background(
//                        GeometryReader {
//                            Color.clear.preference(key: ContentHeightKey.self, value: $0.size.height)
//                        }
//                    )
//
//                    if scrollHeight < contentHeight{
//
//                        PullUpToRefresh(coordinateSpaceName: spaceName, scrollHeight: scrollHeight){
//                            commentData.getMoreComments(size: 10)
//                            //commentData.refreshComment()
//                        }
//                    }
//                }
//                .coordinateSpace(name: spaceName)
//                .onAppear(){
//                    scrollHeight = scrollProxy.size.height
//                    print("ScrollHeight: \(scrollHeight)")
//                }
//                .onPreferenceChange(ContentHeightKey.self) {
//
//                    print ("contentHeight >> \($0)")
//                    contentHeight = $0
//
//                }
//            }
            
            Divider()
                .shadow(color: .gray, radius: 3, x: 0, y: -3)
                .mask(Rectangle().padding(.top, -20)) /// here!
            
            Rectangle()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 9, alignment: .center)
                .foregroundColor(.white)
                .overlay(
                    
                    HStack(spacing: 10){
                        
                        Capsule().frame(width: UIScreen.main.bounds.width * 0.8, height: 50)
                            .foregroundColor(Constants.ShadeGray)
                            .overlay(
                            
                                TextField("Add a comment...", text: $commentText)
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom:0 , trailing: 0))
                                    .focused($focus)
                                    .onTapGesture {
                                        focus.toggle()
                                    }
                            )
                            .padding(.trailing)
                        
                        Button(action: {
                            
                            if let commentId : String = newCommentData.commentFocusedId{
                                newCommentData.commentOnComment(text: commentText, postId: commentData.postId, commentId: commentId)
                            }else{
                                newCommentData.commentOnPost(text: commentText, postId: commentData.postId)
                            }
                            commentText = ""
                            
                        }){
                            
                            Image("send")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 20, height: 20)
                                .background(
                                    Circle()
                                        .foregroundColor(commentText.isEmpty ? Color.gray : Constants.ShadeTeal)
                                        .frame(width: 45, height: 45)
                                )
                            
                        }
                        .disabled(newCommentData.isPosting)
                        .disabled(commentText.isEmpty)
                    }
                    .padding()
                )
                .padding(.vertical)
        }
        .frame(width: Constants.width)
        .alert(isPresented: $alert) {
            return Alert(title: Text("Comment successfully"), dismissButton: .default(Text("Got it!"), action: {
                commentData.getMoreComments(size: 10)
                //commentData.refreshComment()
            }))
        }
        .onAppear(){
            if !(commentData.comments?.isEmpty ?? false){
                commentData.getMoreComments(size: 10)
            }
            newCommentData.currentCommentData = commentData
        }
        .fullScreenCover(item: $videoToPlay) { info in
            HomePostDisplayer(uid: info.uid, pid: info.pid)
        }
    }
}


