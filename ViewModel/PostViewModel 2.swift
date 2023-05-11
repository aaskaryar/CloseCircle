//
//  PostViewModel.swift
//  Social App
//
//  Created by Balaji on 16/09/20.
//

import SwiftUI
import Firebase

class PostViewModel : ObservableObject{
    //@ObservedObject var settingData : SettingViewModel()
    
    @Published var posts : [PostModel] = []
    @Published var noPosts = true
    @Published var newPost = false
    @Published var flip = false
    @Published var updateId = ""
    @Published var cards : [CardModel] = []
    @Published var user : UserModel = UserModel.emptyUserModel
    private let decoder = JSONDecoder()
    private var followingListeners : [String: DatabaseHandle] = [String: DatabaseHandle]()
    
    let uid = Auth.auth().currentUser!.uid
    let ref = Firestore.firestore()
    let realtime_ref = Database.database().reference()
    
    init(userInfo : UserModel) {

        self.user = userInfo
        //self.getAllMyPosts()
        //print("followingHobbies", user.followingHobbies)
        for (_, hobbies) in userInfo.followingUsers{
            for hobby_id in hobbies{
                self.addListenerOnHobby(id: hobby_id)
            }
        }
        for myHobbyId in userInfo.myHobbies{
            self.addListenerOnHobby(id: myHobbyId)
        }

    }
    
    deinit{
        for (_, handler) in followingListeners{
            realtime_ref.removeObserver(withHandle: handler)
        }
    }
    
    func updateUserInfo (userInfo: UserModel){
        
        print("PostViewModel updating")
        let newInfo = userInfo
        
        if(newInfo.followingUsers.isEmpty){
            for (hobbyId, handle) in followingListeners{
                if (!newInfo.myHobbies.contains(hobbyId)){
                    realtime_ref.removeObserver(withHandle: handle)
                    print("Listener on \(hobbyId) successfully removed")
                    cards = cards.filter{ $0.hobby_id != hobbyId}
                }
            }
        }
        
        // iterate through to add new snapshot listeners and remove old on hobbies
        for (followingUid, hobbyArray) in newInfo.followingUsers{
            
            if(user.followingUsers[followingUid] == nil){ // if this is a new user to follow
                
                for hobbyId in hobbyArray{ // add linstener on all the hobbies inside
                    addListenerOnHobby(id: hobbyId)
                }
                
            }else{ // not a new user, check if there is new hobby inside
                
                var oldHobbyArray : [String] = user.followingUsers[followingUid]!
                var newHobbyArray : [String] = hobbyArray
                
                // iterate through to delete the hobby that's in both array
                // what's left in oldHobbyArray need to be deleted
                // what's left in newHobbyArray need to be added
                for (oldHobbyId) in oldHobbyArray{
                    
                    if(hobbyArray.contains(oldHobbyId)){ // if still there, leave
                        oldHobbyArray = oldHobbyArray.filter{$0 != oldHobbyId}
                        newHobbyArray = newHobbyArray.filter{$0 != oldHobbyId}
                    }
                    
                }
                
                for hobbyId in oldHobbyArray{
                    guard let handle = followingListeners[hobbyId] else {return}
                    realtime_ref.removeObserver(withHandle: handle)
                    print("Listener on \(hobbyId) successfully removed")
                    cards = cards.filter{ $0.hobby_id != hobbyId}
                }
                for hobbyId in newHobbyArray{
                    addListenerOnHobby(id: hobbyId)
                }
            }
            
        }
        
        var oldHobbyArray : [String] = user.myHobbies
        var newHobbyArray : [String] = newInfo.myHobbies
        
        for hobbyId in newInfo.myHobbies{
            
            if(oldHobbyArray.contains(hobbyId)){ // if still there, leave
                oldHobbyArray = oldHobbyArray.filter{$0 != hobbyId}
                newHobbyArray = newHobbyArray.filter{$0 != hobbyId}
            }
        }
        
        for hobbyId in oldHobbyArray{
            guard let handle = followingListeners[hobbyId] else {return}
            realtime_ref.removeObserver(withHandle: handle)
        }
        for hobbyId in newHobbyArray{
            addListenerOnHobby(id: hobbyId)
        }
        
        user = userInfo
    }
    
    func addListenerOnHobby(id: String){
        if(id == ""){
            return
        }
        print("PostModel: Adding new Listener on Hobby: " + id)
        followingListeners[id] = realtime_ref.child("Posts").child(id).observe(.childAdded, with: { (snapshot) -> Void in
            
            guard var json = snapshot.value as? [String: Any] else {return}
            //print("got one")
            json["id"] = snapshot.key

            do {

              // 5
              let cardData = try JSONSerialization.data(withJSONObject: json)
              // 6
              let card = try self.decoder.decode(CardModel.self, from: cardData)
              // 7
              self.cards.append(card)
              self.cards.sort { (c1, c2) -> Bool in
                return c1.timePosted > c2.timePosted
              }
            } catch {
                print("an error occurred", error)
            }
            
        })
    }
    
//    func getAllFollowingPosts(){
//        print("followingHobbies", settingData.userInfo.followingHobbies)
//
//        for followingHobbyId in settingData.userInfo.followingHobbies{
//            addListenerOnHobby(id: followingHobbyId)
//        }
//    }
    
    // deleting Posts...
    
    func deletePost(id: String){
        
        ref.collection("Posts").document(id).delete { (err) in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
        }
    }
    
    func editPost(id: String){
        
        updateId = id
        // Poping New Post Screen
        newPost.toggle()
    }
    
//    func getAllPosts(){
//
//        ref.collection("Posts").addSnapshotListener { (snap, err) in
//            guard let docs = snap else{
//                self.noPosts = true
//                return
//
//            }
//
//            if docs.documentChanges.isEmpty{
//
//                self.noPosts = true
//                return
//            }
//
//            docs.documentChanges.forEach { (doc) in
//
//                // Checking If Doc Added...
//                if doc.type == .added{
//
//                    // Retreving And Appending...
//                    let title = doc.document.data()["title"] as! String
//                    let time = doc.document.data()["time"] as! Timestamp
//                    let pic = doc.document.data()["url"] as! String
//                    let userRef = doc.document.data()["ref"] as! DocumentReference
//
//                    // getting user Data...
//
//                    fetchUser(uid: userRef.documentID) { (user) in
//
//                        self.posts.append(PostModel(id: doc.document.documentID, title: title, pic: pic, time: time.dateValue(), user: user))
//                        // Sorting All Model..
//                        // you can also doi while reading docs...
//                        self.posts.sort { (p1, p2) -> Bool in
//                            return p1.time > p2.time
//                        }
//                    }
//                }
//
//                // removing post when deleted...
//
//                if doc.type == .removed{
//
//                    let id = doc.document.documentID
//
//                    self.posts.removeAll { (post) -> Bool in
//                        return post.id == id
//                    }
//                }
//
//                if doc.type == .modified{
//
//                    // firebase is firing modifed when a new doc writed
//                    // I dont know Why may be its bug...
//                    print("Updated...")
//                    // Updating Doc...
//
//                    let id = doc.document.documentID
//                    let title = doc.document.data()["title"] as! String
//
//                    let index = self.posts.firstIndex { (post) -> Bool in
//                        return post.id == id
//                    } ?? -1
//
//                    // safe Check...
//                    // since we have safe check so no worry
//
//                    if index != -1{
//
//                        self.posts[index].title = title
//                        self.updateId = ""
//                    }
//                }
//            }
//        }
//    }
}



