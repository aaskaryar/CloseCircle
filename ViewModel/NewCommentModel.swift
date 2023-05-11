//
//  NewCommentModel.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 6/1/22.
//

import SwiftUI
import Firebase

class NewCommentModel : ObservableObject{
    
    @Published var isPosting = false
    @Published var success = false
    @Published var commentFocusedId : String? = nil
    var currentCommentData : CommentViewModel? = nil
    var userInfo : UserModel
    private let encoder = JSONEncoder()
    
    let uid = auth.currentUser!.uid
    
    init(userInfo: UserModel){
        self.userInfo = userInfo
    }
    
    func updateUserInfo(userInfo: UserModel){
        self.userInfo = userInfo
    }
    
    // There is only two functions
    // This function is used to commentOnPost, just like what it says
    // I think PostID is in CommentViewModel
    // also you can use isPosting and success to disable the view and send
    // alert when posting new comments is done
    // also you can jump to line 57 for the second function
    func commentOnPost(text: String, postId: String){
        
        isPosting = true
        
        let comment : CommentModel = CommentModel(uid: uid, timePosted: Date(), text: text, commentBack: nil)
        
        do {
            let data = try self.encoder.encode(comment)

            let json = try JSONSerialization.jsonObject(with: data)

            // 6
            let reference = realtime_ref.child("Comments").child(postId).childByAutoId()
            
            reference.setValue(json){
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                    self.success = false
                } else {
                    //print("Data saved successfully!")
                    self.success = true
                    //print(reference.key)
                    let commentId = reference.key as! String
                    
                    self.updateCommentList(postId: postId, commentId: commentId)
                    self.sendNotificationForCommenting(postId: postId)
                    if let commentData = self.currentCommentData{
                        var comment = comment
                        comment.profilepicurl = self.userInfo.imageurl
                        comment.profileusername = self.userInfo.username
                        commentData.comments![commentId] = comment
                    }
                }
                self.isPosting = false
              }
            
          }catch{
              print("an error occurred", error)
              self.success = false
              self.isPosting = false
          }
        
        
    }
    
    
    // This function is for commentOnComments
    // This function is used to commentOnComment, just like what it says
    // The commentId in the CommentView can be get by the id, which I
    // have written in the Comments in CommentViewModel
    // BAGELS!!!
    func commentOnComment(text: String, postId: String, commentId: String){
        
        isPosting = true
        
        let comment : CommentModel = CommentModel(uid: uid, timePosted: Date(), text: text, commentBack: nil)
        
        do {
            let data = try self.encoder.encode(comment)

            let json = try JSONSerialization.jsonObject(with: data)

            // 6
            realtime_ref.child("Comments").child(postId).child(commentId).child("commentBack").childByAutoId().setValue(json){
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                    self.success = false
                } else {
                    print("Data saved successfully!")
                    self.success = true
//                    if let commentData = self.currentCommentData{
//                        commentData.refreshComment()
//                    }
                    self.sendNotificationForCommenting(postId: postId)
                }
                
                self.isPosting = false
              }
            
          }catch{
              print("an error occurred", error)
              self.success = false
              self.isPosting = false
          }
        
    }
    
    func updateCommentList(postId: String, commentId: String){
        
        let commentListRef = ref.collection("CommentList").document(postId)
//
//        commentListRef.updateData([
//            "list": FieldValue.arrayUnion([commentId])
//        ])
        
        commentListRef.getDocument { (document, error) in
            if let document = document {

                if document.exists{

                    commentListRef.updateData([
                        "list": FieldValue.arrayUnion([commentId])
                    ])

                }else{

                    commentListRef.setData([
                        "list": FieldValue.arrayUnion([commentId])
                    ])
                }
            }
            
            self.isPosting = false
        }
    }
    
    func sendNotificationForCommenting(postId: String){
        fetchPost(postId: postId) { card in
            guard let card = card else {return}
            let toUid = card.uid
//            uploadNotification(toUid: toUid, notif: NotificationModel(id: "", fromUid: self.uid, fromUsername: nil, fromImageUrl: nil, type: Constants.NOTIFICATION_POST, postId: postId, hobbyName: "", commentId: nil))
            let userInfo = self.userInfo
            uploadNotification(toUid: toUid, notif: NotificationModel(id: "", toUid: toUid, from_uid: userInfo.uid, from_username: userInfo.username, from_url: userInfo.imageurl, type: Constants.NOTIFICATION_POST, postId: postId, hobbyName: "", commentId: nil))
        }
    }
    
}
