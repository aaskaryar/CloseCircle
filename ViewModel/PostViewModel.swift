//
//  PostViewModel.swift
//  Social App
//
//  Created by Yuxuan Guo on 21/01/22.
//

import SwiftUI
import Firebase

class PostViewModel : ObservableObject{
    //@ObservedObject var settingData : SettingViewModel()
    
    @Published var noPosts = true
    @Published var cards : [CardModel] = []
    private var PostsQueue : Queue<String> = Queue<String>()
    @Published var user : UserModel = UserModel.emptyUserModel
    // I create this to read what hobby exactly did this have
    
    @Published var hobbyList : [String] = [String]()
    private var hobbyCounts : [String: Int] = [String: Int]()
    private var hobbyMap : [String: String] = [String: String]()
    
    // this is just for easy access for the selected hobbies for cardViews
    @Published var selectedHobbies : [String] = [String]()
    // @Published var showingHobbies = false
    private var oldestPostDate : Date = Date()
    private var newPostListener : DatabaseHandle? = nil
    var cardIds = [String]()
    
    let uid = auth.currentUser!.uid
    let PostRef = ref.collection("Posts")
    private var PostListeners : [DatabaseHandle] = [DatabaseHandle]()
    
    init(userInfo : UserModel) {

        self.user = userInfo
        // var hobbiesNameList = [String]()
        //self.getAllMyPosts()
        //print("followingHobbies", user.followingHobbies)
        
        listenOnNewPosts()
        
        fetchPostDic() { dic in
            
            guard let dic = dic else {return}
            
            let PostDic = dic.sorted(by: { first, second in
                first.value > second.value
            }).map({$0.key})
            
            for id in PostDic{
                self.PostsQueue.enqueue(id)
            }
            
            self.getOldPosts(size: 10)
        }
        
        
        
        for (followingUid, hobbies) in userInfo.followingUsers{
            for hobby_id in hobbies{
                //self.addListenerOnHobby(id: hobby_id)
                fetchHobby(uid: followingUid, hid: hobby_id, refresh: true){ hobby in
                    guard let hobby = hobby else {
                        print("hobby not found from db")
                        return
                    }

                    self.addHobbyInList(hobby: hobby)
                }
            }
        }
        for myHobbyId in userInfo.myHobbies{
            //self.addListenerOnHobby(id: myHobbyId)
            fetchHobby(uid: userInfo.uid, hid: myHobbyId, refresh: true){ hobby in
                guard let hobby = hobby else {
                    print("hobby not found from db")
                    return
                }
                self.addHobbyInList(hobby: hobby)
            }
        }

    }
    
    deinit{
        if let newPostListener = newPostListener {
            realtime_ref.removeObserver(withHandle: newPostListener)
        }
        for handle in PostListeners{
            realtime_ref.removeObserver(withHandle: handle)
        }
    }
    
    func removeHobbyInList(hobbyId: String){
        guard let hobbyName = self.hobbyMap[hobbyId] else{return}
        hobbyMap[hobbyId] = nil
        if let currentCount = hobbyCounts[hobbyName]{
            hobbyCounts[hobbyName] = currentCount - 1
        }else{
            hobbyCounts[hobbyName] = 0
        }
        if(hobbyCounts[hobbyName] == 0){
            hobbyList = hobbyList.filter{$0 != hobbyName}
            hobbyCounts[hobbyName] = nil
        }
        print(hobbyList)
        print(hobbyMap)
        print(hobbyCounts)
    }
    
    func addHobbyInList(hobby: HobbyModel){
        if(self.hobbyCounts[hobby.name] == nil){
            self.hobbyList.append(hobby.name)
            self.hobbyCounts[hobby.name] = 1
        }else{
            self.hobbyCounts[hobby.name]! += 1
        }
        self.hobbyMap[hobby.id] = hobby.name

    }
    
    func updateUserInfo (userInfo: UserModel){
        
        print("PostViewModel updating")
        let newInfo = userInfo
        
        if(newInfo.followingUsers.isEmpty){
            for (_, hobbyIds) in user.followingUsers{
                for hobbyId in hobbyIds{
                    self.removeListeningOnHobby(hobbyId: hobbyId, own: false)
                }
            }
        }else{
            
            var unfollowingUserUids = user.followingUsers.map{$0.key}
            
            // iterate through to add new snapshot listeners and remove old on hobbies
            for (followingUid, hobbyArray) in newInfo.followingUsers{
                
                if(user.followingUsers[followingUid] == nil){ // if this is a new user to follow
                    
                    for hobbyId in hobbyArray{ // add linstener on all the hobbies inside
                        addListenerOnHobby(uid: followingUid, hobbyId: hobbyId)
                    }
                    
                }else{ // not a new user, check if there is new hobby inside
                    
                    unfollowingUserUids = unfollowingUserUids.filter{$0 != followingUid}
                    
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
                        removeListeningOnHobby(hobbyId: hobbyId, own: false)
                    }
                    for hobbyId in newHobbyArray{
                        addListenerOnHobby(uid: followingUid, hobbyId: hobbyId)
                    }
                }
                
            }
            
            for unfollowingUid in unfollowingUserUids{
                
                guard let hobbyIds = user.followingUsers[unfollowingUid] else {continue}
                for hobbyId in hobbyIds{
                    removeListeningOnHobby(hobbyId: hobbyId, own: false)
                }
            }
            
        }
        
        // each iteration one of the uid in the newFollowingUsers will be deleted
        // what got left are the uids we not follow anymore
       
        
        var oldHobbyArray : [String] = user.myHobbies
        var newHobbyArray : [String] = newInfo.myHobbies
        
        for hobbyId in newInfo.myHobbies{
            
            if(oldHobbyArray.contains(hobbyId)){ // if still there, leave
                oldHobbyArray = oldHobbyArray.filter{$0 != hobbyId}
                newHobbyArray = newHobbyArray.filter{$0 != hobbyId}
            }
        }
        
        for hobbyId in oldHobbyArray{
            removeListeningOnHobby(hobbyId: hobbyId, own: true)
        }
        for hobbyId in newHobbyArray{
            addListenerOnHobby(uid: userInfo.uid, hobbyId: hobbyId)
        }
        
        user = userInfo
    }
    
    func removeListeningOnHobby(hobbyId: String, own: Bool){
        fetchHobbyPostList(hobbyId: hobbyId) { postList in
            guard let postList = postList else {
                print("hobbyPostList not found from db")
                return
            }
            
            print("PostList: ", postList)
            
            for postId in postList.keys{
                print("deleting \(postId)")
                realtime_ref.child("PostLists").child(self.uid).child("oldPosts").child(postId).removeValue()
                realtime_ref.child("PostLists").child(self.uid).child("newPosts").child(postId).removeValue()
                if own{
                    realtime_ref.child("Posts").child(postId).removeValue()
                }
            }
            
            if own{
                realtime_ref.child("HobbyPostLists").child(hobbyId).removeValue()
            }
        }
        cards = cards.filter{$0.hobby_id != hobbyId}
        removeHobbyInList(hobbyId: hobbyId)
    }
    
    func addListenerOnHobby(uid: String, hobbyId: String){
        fetchHobbyPostList(hobbyId: hobbyId) { postList in
            guard let postList = postList else {
                print("hobbyPostList not found from db")
                return
            }
            
            for (postId, time) in postList{
                
                // this means not yet get them
                if time < self.oldestPostDate{
                    self.PostsQueue.enqueue(postId)
                }else{
                    self.PostListeners.append(listenOnPost(postId: postId) { card in
                        self.cards = self.cards.filter({$0.id != postId})
                        
                        guard let card = card else {return}
                        
                        self.cards.append(card)
                        self.cards = self.cards.sorted(by: { first, second in
                            first.timePosted > second.timePosted
                        })
                    })
                }
                realtime_ref.child("PostLists").child(self.uid).child("oldPosts").child(postId).setValue(time.timeIntervalSince1970)
            }
        }
        
        fetchHobby(uid: uid, hid: hobbyId, refresh: false){ hobby in
            guard let hobby = hobby else {
                print("hobby not found from db")
                return
            }
            self.addHobbyInList(hobby: hobby)
        }
        
    }
    
    func getOldPosts(size: Int){
        
        var i = 0
        
        while i < size{
            
            i += 1
            
            guard let id = PostsQueue.dequeue() else{return}
            
            if !checkIsDuplicatedCardAndDeleteInNewPostLists(id: id){
                
                self.PostListeners.append(listenOnPost(postId: id) { card in
                    
                    self.cards = self.cards.filter({$0.id != id})
                    
                    if let card = card{
                        self.cards.append(card)
                        self.oldestPostDate = card.timePosted
                        self.cards = self.cards.sorted(by: { first, second in
                            first.timePosted > second.timePosted
                        })
                    }
                })
            }
        }
    }
    
    func listenOnNewPosts(){
        
        newPostListener = realtime_ref.child("PostLists").child(uid).child("newPosts").observe(.childAdded, with: { (snapshot) -> Void in
            
            print(snapshot)
            guard let id = snapshot.key as? String else {return}
           
            if !self.checkIsDuplicatedCardAndDeleteInNewPostLists(id: id){
                
//                fetchPost(postId: id) { card in
//                    print(card)
//                }
                
                self.PostListeners.append(listenOnPost(postId: id) { card in
                    
                    self.cards = self.cards.filter({$0.id != id})
                    
                    if let card = card{
                        self.cards.insert(card, at: 0)
                        self.oldestPostDate = card.timePosted
                        
                        self.cards = self.cards.sorted(by: { first, second in
                            first.timePosted > second.timePosted
                        })
                    }
                })
            }
        })
    }
    
    func checkIsDuplicatedCardAndDeleteInNewPostLists(id: String) -> Bool{
        
        if cardIds.contains(id){
            
            realtime_ref.child("PostLists").child(uid).child("newPosts").child(id).removeValue()
            return true
            
        }else{
            cardIds.append(id)
            return false
        }
        
//        if cards.contains(where: { sameCard in
//            sameCard.id == id
//        }){
//            realtime_ref.child("PostLists").child(uid).child("newPosts").child(id).removeValue()
//            return true
//        }else{
//            return false
//        }
    }
    
    func fetchPostDic(completion: @escaping ([String: Date]?) -> ()){
        
        realtime_ref.child("PostLists").child(uid).child("oldPosts").getData(completion: { error, snapShot in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            guard let snapshot = snapShot else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            if let dictionary = snapshot.value as? [String: TimeInterval]{
                
                var dic = [String: Date]()
                
                for (id, time) in dictionary{
                    dic[id] = Date(timeIntervalSince1970: time)
                }
                DispatchQueue.main.async {
                    completion(dic)
                }
            }else{
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        })
    }
    
    func deletePost(card: CardModel){
        
        cards = cards.filter{$0 != card}
        
        deletePostInFirebase(hobbyId: card.hobby_id, postId: card.id)
    }
    
    func deletePostInFirebase(hobbyId: String, postId: String){
        
        realtime_ref.child("HobbyPostLists").child(hobbyId).child(postId).removeValue()
        
        realtime_ref.child("Posts").child(postId).removeValue()

    }
}

var postDic : [String: CardModel] = [String: CardModel]()

func fetchPost(postId: String, completion: @escaping (CardModel?) -> ()){
    
    if let card = postDic[postId]{
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                completion(card)
            }
            return
        }
    }
    
    let decoder = JSONDecoder()
    
    realtime_ref.child("Posts").child(postId).getData(){ (error, snapShot) in
        
        var card : CardModel? = nil
        
        if error != nil{
            
            print(error!.localizedDescription)
            
        }else if let snapshot = snapShot{
            
            guard var json = snapshot.value as? [String: Any] else {return}
            //print("got one")
            json["id"] = snapshot.key
            if(json["taggedPeople"] == nil){
                json["taggedPeople"] = [String]()
            }
            if(json["categories"] == nil){
                json["categories"] = [String]()
            }
            
            if(json["isVideo"] == nil){
                json["isVideo"] = false
            }
            //print(json)
                
            do {

                let cardData = try JSONSerialization.data(withJSONObject: json)
                card = try decoder.decode(CardModel.self, from: cardData)
                
            } catch {
                print("an error occurred", error)
            }
        }else{
            realtime_ref.child("PostLists").child(auth.currentUser!.uid).child("newPosts").child(postId).removeValue()
            realtime_ref.child("PostLists").child(auth.currentUser!.uid).child("oldPosts").child(postId).removeValue()
        }
        
        DispatchQueue.main.async {
            completion(card)
        }
    }
}

func listenOnPost(postId: String, completion: @escaping (CardModel?) -> ()) -> DatabaseHandle{
    
    return realtime_ref.child("Posts").child(postId).observe(DataEventType.value) { snapshot in
        
        var card : CardModel? = nil
        
        if snapshot.exists(){
            print("exist")
        }
        
        if let value = snapshot.value{
            
            guard var json = value as? [String: Any] else {
//                realtime_ref.child("PostLists").child(auth.currentUser!.uid).child("newPosts").child(postId).removeValue()
//                realtime_ref.child("PostLists").child(auth.currentUser!.uid).child("oldPosts").child(postId).removeValue()
                return
            }
            //print("got one")
            json["id"] = snapshot.key
            if(json["taggedPeople"] == nil){
                json["taggedPeople"] = [String]()
            }
            if(json["categories"] == nil){
                json["categories"] = [String]()
            }
            if(json["isVideo"] == nil){
                json["isVideo"] = false
            }
            
            //print(json)
                
            do {

                let cardData = try JSONSerialization.data(withJSONObject: json)
                card = try decoder.decode(CardModel.self, from: cardData)
                
            } catch {
                print("an error occurred", error)
            }
        }else{
            realtime_ref.child("PostLists").child(auth.currentUser!.uid).child("newPosts").child(postId).removeValue()
            realtime_ref.child("PostLists").child(auth.currentUser!.uid).child("oldPosts").child(postId).removeValue()
        }
        
        DispatchQueue.main.async {
            completion(card)
        }
    }
}

func fetchHobbyPostList(hobbyId: String, completion: @escaping ([String: Date]?) -> ()){
    
    //print("fetchHobbyPostList called by ",completion)
    
    realtime_ref.child("HobbyPostLists").child(hobbyId).getData(completion: { error, snapShot in
        
        guard error == nil else {
            print(error!.localizedDescription)
            return;
        }
        guard let snapshot = snapShot else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        print("value: ", snapshot.value)
        
        if let dictionary = snapshot.value as? [String: TimeInterval]{
            
            var dic = [String: Date]()
            
            for (id, time) in dictionary{
                dic[id] = Date(timeIntervalSince1970: time)
            }
            DispatchQueue.main.async {
                completion(dic)
            }
        }else{
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    })
    
}



