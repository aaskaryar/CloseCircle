//
//  FetchComment.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 6/3/22.
//

import SwiftUI
import FirebaseDatabase

let decoder = JSONDecoder()

func fetchComment(postId: String, commentId: String, completion: @escaping (CommentModel) -> ()){
    
    
    let commentsQuery : DatabaseQuery = realtime_ref.child(Constants.DATABASE_COMMENTS).child(postId).child(commentId)
    
//        let handler : DatabaseHandle = commentsQuery.observe(DataEventType.value, with: { snapshot in
    // get data once
    commentsQuery.getData(completion: { error, snapShot in
        
        guard error == nil else {
            print(error!.localizedDescription)
            return;
        }
        guard let snapshot = snapShot else {return}
        
        if let dictionary = snapshot.value as? [String: Any]{
            
            do {
                let commentData = try JSONSerialization.data(withJSONObject: dictionary)
                
                var comment = try decoder.decode(CommentModel.self, from: commentData)
                
                fetchUser(uid: comment.uid){ user in
                    
                    guard let user = user else {return}
                    
                    comment.profilepicurl = user.imageurl
                    comment.profileusername = user.username
                    
                    DispatchQueue.main.async {
                        completion(comment)
                    }
                    
                }
                
            } catch {
                print("an error occurred", error)
            }
        }
    })
}

func listenOnComment(postId: String, commentId: String, completion: @escaping (CommentModel?) -> ()) -> DatabaseHandle{
    
    
    let commentsQuery : DatabaseQuery = realtime_ref.child(Constants.DATABASE_COMMENTS).child(postId).child(commentId)
    
//        let handler : DatabaseHandle = commentsQuery.observe(DataEventType.value, with: { snapshot in
    // get data once
    return commentsQuery.observe(DataEventType.value, with: { snapShot in
        
        if let dictionary = snapShot.value as? [String: Any]{
            
            do {
                let commentData = try JSONSerialization.data(withJSONObject: dictionary)
                
                var comment = try decoder.decode(CommentModel.self, from: commentData)
                
                fetchUser(uid: comment.uid){ user in
                    
                    guard let user = user else {
                        
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                        return
                    }
                    
                    comment.profilepicurl = user.imageurl
                    comment.profileusername = user.username
                    
                    DispatchQueue.main.async {
                        completion(comment)
                    }
                    
                }
                
            } catch {
                print("an error occurred", error)
            }
        }else{
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    })
}
