//
//  SearchUserModel.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/19/22.
//
import SwiftUI
import FirebaseFirestoreSwift
import Firebase

class SearchUserModel : ObservableObject{
    
    var userInfo : UserModel
    var hobbies : [HobbyModel]
    var hobbyPostLists : [String: Queue<String>] =  [String: Queue<String>]()
    @Published var hobbyPosts : [String : [CardModel]]
    @Published var hobbyOnFocus : HobbyModel?
    var detail : Bool = false
    private var PostListeners : [DatabaseHandle] = [DatabaseHandle]()
    
    init(userInfo: UserModel){
        
        self.userInfo = userInfo
        self.hobbies = [HobbyModel]()
        self.hobbyPosts = [String : [CardModel]]()
        
        for hobbyId in userInfo.myHobbies{
            
            //fetchPostListsForHobby(hobbyId: hobbyId)
            
            fetchHobby(uid: userInfo.uid, hid: hobbyId, refresh: true) { hobby in
                guard let hobby = hobby else {
                    return
                }
                self.hobbies.append(hobby)
                self.hobbyPosts[hobby.id] = [CardModel]()
                
                self.hobbies = self.hobbies.sorted(by: { first, second in
                    first.id > second.id
                })
            }
        }
    }
    
    deinit{
        for handle in PostListeners{
            realtime_ref.removeObserver(withHandle: handle)
        }
    }
    
    func fetchPostListsForHobby(hobbyId: String){
        
        fetchHobbyPostList(hobbyId: hobbyId) { postList in
            
            guard let postList = postList else {
                print("hobbyPostList not found from db")
                return
            }
            
            
            
            let sortedPostList = postList.sorted {$0.value > $1.value}
            
            let sortedPostIds = Array(sortedPostList.map({ $0.key }))
            
            var queue = Queue<String>()
            
            for postId in sortedPostIds{
                
                queue.enqueue(postId)
            }
            
            self.hobbyPostLists[hobbyId] = queue
            
            print("queue: ", queue)
            
            
        }
    }
    
    func fetchPostsForHobby(hobbyId: String){
        
        if !(hobbyPosts[hobbyId]?.isEmpty ?? false) {
            return
        }
        
        getMorePosts(size: 15, hobbyId: hobbyId)
    }
    
    func getMorePosts(size: Int, hobbyId: String){
        
        guard var queue = hobbyPostLists[hobbyId] else{
            return
        }
        
        for i in 1...size{
            
            guard let postId = queue.dequeue() else {
                return
            }
            
            PostListeners.append(listenOnPost(postId: postId) { card in
                guard let card = card else {
                    return
                }
                
                guard let list = self.hobbyPosts[hobbyId] else{
                    return
                }
                self.hobbyPosts[hobbyId] = self.hobbyPosts[hobbyId]?.filter({$0.id != postId})
                self.hobbyPosts[hobbyId]!.append(card)
                self.hobbyPosts[hobbyId] = self.hobbyPosts[hobbyId]?.sorted(by: { first, second in
                    first.timePosted > second.timePosted
                })
            })
            
            hobbyPostLists[hobbyId] = queue
        }
    }
}
