//
//  FullCommentView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 6/1/22.
//

import SwiftUI

struct FullCommentView: View {

    
    @State var commentText : String = ""
    @ObservedObject var commentData : CommentViewModel
    @State var firstAppear = true
    @State private var offset = CGFloat.zero
    @State var scrollHeight = CGFloat.zero
    @State var contentHeight = CGFloat.zero
    @State var scrollOffset = CGFloat.zero
    @State var commentIdToDelete : AlertInfo?
    @FocusState private var focus: Bool
    //@ObservedObject var postData : PostViewModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var newCommentData : NewCommentModel
    
    init(commentData: CommentViewModel){
        _commentData = ObservedObject(wrappedValue: commentData)
    }
    
    var body: some View {
        
        VStack{
            
            ZStack{
                
                HStack{
                    
                    Spacer()
                    
                    Text("Comments")
                        .font(Font.custom("DM Sans", size: 22))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                }
                .padding()
                
                HStack{
                    
                    Spacer()
                    
                    Button(action: {dismiss()}){
                        
                        Image(systemName: "xmark")
                            .frame(width: 12, height: 12)
                            .foregroundColor(.white)
                            .background(
                                Constants.ShadeTeal
                                    .frame(width: 36, height: 36)
                                    .clipShape(Circle())
                            )
                        
                    }
                    
                }.padding(.horizontal)
            }
            
            GeometryReader{ scrollProxy in
                
                ScrollView{
                    
                    PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                        
                        //commentData.refreshComment()
                        
                        if scrollHeight > contentHeight{
                            commentData.getMoreComments(size: 10)
                            print("out")
                        }
                        
                    }
                    
                    if commentData.comments!.keys.sorted(by: <).isEmpty{
                        Text("No Comments For Now")
                    }
                    
                    VStack(spacing: 1){
                        
                        ScrollViewReader{ proxy in
                            
                            ForEach(commentData.comments!.keys.sorted(by: <), id: \.self) { id in
                                
                                let comment = commentData.comments![id]
                                
                                CommentView(commentId: id, comment: comment!, commentIdToDelete: $commentIdToDelete)
                                
                            }
                        }
                        
                    }
                    .coordinateSpace(name: commentData.postId)
                    .background(

                        Group{
                            GeometryReader {
                                Color.clear.preference(key: ContentHeightKey.self,
                                                       value: $0.size.height)

                            }
                            GeometryReader {
                                Color.clear.preference(key: ViewOffsetKey.self,
                                    value: -$0.frame(in: .named("pullToRefresh")).origin.y)
                            }
                        }

                    )
                    if scrollHeight < contentHeight{
                        
                        PullUpToRefresh(coordinateSpaceName: "pullToRefresh", scrollHeight: scrollHeight){
                            commentData.getMoreComments(size: 10)
                        }
                    }
                
                }
                .coordinateSpace(name: "pullToRefresh")
                .onAppear(){
                    scrollHeight = scrollProxy.size.height
                    print("ScrollHeight: \(scrollHeight)")
                }
                .onPreferenceChange(ContentHeightKey.self) {
                    
                    print ("contentHeight >> \($0)")
                    contentHeight = $0
                    
                }
                .onPreferenceChange(ViewOffsetKey.self) {
                    // print ("offset >> \($0)")
                    scrollOffset = $0
                }
        //        .frame(maxHeight:.infinity)
                
            }
            
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
        .padding(.horizontal)
        .onAppear(){
            newCommentData.currentCommentData = commentData
            if firstAppear{
                commentData.getMoreComments(size: 10)
                print("firstAppear")
            }
            firstAppear = false
        }
//        .alert(isPresented: $newCommentData.success){
//            Alert(title: Text("Comment successfully"), dismissButton: .default(Text("Got it!")))
//        }
        .alert(item: $commentIdToDelete) { info in
            
            Alert(title: Text("Confirm Delete Comment"), message: nil, primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete"), action: {
                commentData.deleteCommentInFirebase(commentId: info.Message)
                commentData.comments = commentData.comments?.filter{$0.key != info.Message}
            }))
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct ContentHeightKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

