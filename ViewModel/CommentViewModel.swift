//
//  CommentViewModel.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 5/31/22.
//

import SwiftUI
import Firebase
import FirebaseDatabase

class CommentViewModel: ObservableObject {
    
    // To RANDI:
    // All the comments will be get into this dictionary
    // when showing them, you can iterate through comments.map{$0.keys}
    // which will be the id of the comments.
    // and get the actually comments by comments[id]
    // Now only support 2 level in the tree, which means
    // you cannot comment on the comments that comment on comment
    // you can only comment on the comments that comment on post
    // After finish reading this jump to line 49
    @Published var comments : [String : CommentModel]? = [String : CommentModel]()
    private var commentsHandles : [DatabaseHandle] = [DatabaseHandle]()
    public var postTime : Date
    public var postId : String
    public var CurrentlyGetCommentNum : Int = 0
    
    let uid = auth.currentUser!.uid
//    private var commentsModifyListeners : [DatabaseHandle] = [DatabaseHandle]()
//    private var commentsRemoveListeners : [DatabaseHandle] = [DatabaseHandle]()
    private let decoder = JSONDecoder()
    
    init(postId : String, postTime: Date){
        self.postId = postId
        self.postTime = postTime
        getMoreComments(size: 1)
    }
    
    deinit{
        for handle in commentsHandles{
            realtime_ref.removeObserver(withHandle: handle)
        }
    }
    
//    deinit{
//        for handler in commentsModifyListeners{
//            realtime_ref.removeObserver(withHandle: handler)
//        }
//        for handler in commentsRemoveListeners{
//            realtime_ref.removeObserver(withHandle: handler)
//        }
//    }
    
    
    func getMoreComments(size: Int){
        
        print("getMoreComments called")
        
        fetchCommentList(postId: postId){ list in
            
            print(list)
            
            var lastIndex = self.CurrentlyGetCommentNum
            
            print("lastIndex: ", lastIndex)
            
            for (index, commentId) in list.enumerated(){
                
                
                
                if list.count == self.CurrentlyGetCommentNum {
                    break
                }
                
                if index >= self.CurrentlyGetCommentNum && index < self.CurrentlyGetCommentNum + size{
                    
                    print("\(index) \(commentId)")
                    
                    lastIndex += 1
                    
                    self.commentsHandles.append(listenOnComment(postId: self.postId, commentId: commentId){ comment in
                        if comment == nil{
                            lastIndex -= 1
                        }
                        self.comments![commentId] = comment
                    })
                }
                
                self.CurrentlyGetCommentNum = lastIndex
                print(self.CurrentlyGetCommentNum)
            }
        }
        
    }
    
//    func refreshComment(){
//
//        print("refreshedComments called")
//
//        var refreshedComments : [String : CommentModel] = [String: CommentModel]()
//
//        fetchCommentList(postId: postId){ list in
//
//            print(list)
//
//            if list.isEmpty{
//                self.CurrentlyGetCommentNum = 0
//                self.comments = refreshedComments
//            }else{
//
//                if list.count < self.CurrentlyGetCommentNum{
//
//                    self.CurrentlyGetCommentNum = list.count
//
//                }
//
//                for (index, commentId) in list.enumerated(){
//
//                    print("\(index) \(commentId)")
//
//                    if index == self.CurrentlyGetCommentNum{
//
//                        break
//
//                    }else{
//
//                        fetchComment(postId: self.postId, commentId: commentId){ comment in
//
//                            refreshedComments[commentId] = comment
//
//                            if index == self.CurrentlyGetCommentNum - 1{
//
//                                self.comments = refreshedComments
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    func fetchCommentList(postId: String, completion: @escaping ([String]) -> ()){
        
        ref.collection("CommentList").document(postId).getDocument{(snapshot, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            
            guard let doc = snapshot else {return}
            
            var list : [String] = [String]()
            
            if doc.data()?["list"] != nil{
                list = doc.data()?["list"] as! [String]
            }
            
            DispatchQueue.main.async {
                completion(list)
            }
        }
    }
    
    func deleteCommentInFirebase(commentId: String){
        
        ref.collection("CommentList").document(postId).updateData([
            "list": FieldValue.arrayRemove([commentId])
        ])
        
        realtime_ref.child("Comments").child(commentId).removeValue()
        
    }
}
