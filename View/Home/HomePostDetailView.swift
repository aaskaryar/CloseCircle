//
//  HomeHobbyDetail.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/5/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomePostDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    var card : CardModel
    @State var isLoading = true
    @State var userInfo : UserModel?
    @State var hobbyToFocus : HobbyModel?
    
//    init(postData: PostViewModel, newCommentData: NewCommentModel, hobby: HobbyModel){
//        self.postData = postData
//        self.newCommentData = newCommentData
//        self.hobbyPostData = HobbyPostModel(userInfo: postData.user, hobby: hobby)
////        _postData = ObservedObject(wrappedValue: postData)
////        _newCommentData = ObservedObject(wrappedValue: newCommentData)
////        _hobbyPostData = StateObject(wrappedValue: HobbyPostModel(userInfo: postData.user, hobby: hobby))
//        self.hobby = hobby
//    }
    
    var body: some View {
        
//        PostDetailView(postData: postData, newCommentData: newCommentData, card: card, hobbyToFocus: $hobbyToFocus)
        PostDetailView(card: card, hobbyToFocus: $hobbyToFocus)
            .disabled(isLoading)
            .onAppear(perform: {
                fetchUser(uid: card.uid) { user in
                    if let user = user {
                        self.userInfo = user
                        self.isLoading = false
                    }
                }
            })
            .fullScreenCover(item: $hobbyToFocus) { hobby in
               SearchHobbyDetail(userInfo: userInfo!, hobby: hobby)
            }
            .modifier(LoadingModifier(isLoading: $isLoading))
    }
}

//struct HomeHobbyDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeHobbyDetail()
//    }
//}
