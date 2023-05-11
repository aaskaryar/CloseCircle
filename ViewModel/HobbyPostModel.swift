//
//  HobbyPostModel.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/21/22.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

class HobbyPostModel : ObservableObject{
    
    var userInfo : UserModel
    var hobby : HobbyModel
    var hobbyPostLists : Queue<String> =  Queue<String>()
    @Published var hobbyPosts :  [CardModel]
    private var PostListeners : [DatabaseHandle] = [DatabaseHandle]()
    
    init(userInfo: UserModel, hobby: HobbyModel){
        
        self.userInfo = userInfo
        self.hobby = hobby
        self.hobbyPosts =  [CardModel]()
        fetchPostListAndGet15()
        
    }
    
    deinit{
        for handle in PostListeners{
            realtime_ref.removeObserver(withHandle: handle)
        }
    }
    
    func fetchPostListAndGet15(){
        
        let hobbyId = hobby.id
        
        fetchHobbyPostList(hobbyId: hobbyId) { postList in
            
            guard let postList = postList else {
                print("hobbyPostList not found from db")
                return
            }
            
            print("PostList: ", postList)
            
            let sortedPostList = postList.sorted {$0.value > $1.value}
            
            let sortedPostIds = Array(sortedPostList.map({ $0.key }))
            
            var queue = Queue<String>()
            
            for postId in sortedPostIds{
                
                queue.enqueue(postId)
            }
            
            self.hobbyPostLists = queue
            
            self.getMorePosts(size: 15, hobbyId: hobbyId)
        }
    }
    
//    func fetchPostsForHobby(hobbyId: String){
//
//        if !hobbyPosts.isEmpty {
//            return
//        }
//
//        getMorePosts(size: 15, hobbyId: hobbyId)
//    }
    
    func getMorePosts(size: Int, hobbyId: String){
        
        
        for _ in 1...size{
            
            guard let postId = hobbyPostLists.dequeue() else {
                return
            }
            
            PostListeners.append(listenOnPost(postId: postId) { card in
                guard let card = card else {
                    self.hobbyPosts = self.hobbyPosts.filter{ $0.id != postId }
                    return
                }
                
                self.hobbyPosts = self.hobbyPosts.filter({$0.id != postId})
                self.hobbyPosts.append(card)
                self.hobbyPosts = self.hobbyPosts.sorted(by: { first, second in
                    first.timePosted > second.timePosted
                })
                
            })
        }
    }
}
