import SwiftUI
import Firebase

// Global Refernce

//private var userListener : ListenerRegistration? = nil
public let database = Database.database(url: "https://shades-3b5b7-default-rtdb.firebaseio.com/").reference()
//public let database = Firestore.firestore()

private var userDic : [String: UserModel] = [String: UserModel]()

func fetchUser(uid: String,completion: @escaping (UserModel?) -> ()){
    
    if let userInfo = userDic[uid]{
        completion(userInfo)
        return
    }
    
    ref.collection("Users").document(uid).getDocument { (doc, err) in
        if let err = err{
            print(err.localizedDescription)
            completion(nil)
            return
        }
        
        guard let doc = doc else{
            print("empty user snapshot")
            completion(nil)
            return
        }
       
        guard let document = doc.data() else{
            print("empty user doc")
            completion(nil)
            return
        }
        
        let userInfo = getUserFromDocument(uid: doc.documentID, document: document)
        
        userDic[uid] = userInfo
        
        DispatchQueue.main.async {
            completion(userInfo)
        }
        
    }
}

func ListenOnUserChange(uid: String, completion: @escaping (UserModel?) -> ()) -> ListenerRegistration{
    ref.collection("Users").document(uid).addSnapshotListener() { (doc, err) in
        if let err = err{
            print(err.localizedDescription)
            completion(nil)
            return
        }
        
        guard let doc = doc else{
            print("empty user snapshot")
            completion(nil)
            return
        }
        
        guard let document = doc.data() else{
            print("empty user doc")
            completion(nil)
            return
        }
        
        let userInfo = getUserFromDocument(uid: doc.documentID, document: document)
        
        userDic[uid] = userInfo
        
        DispatchQueue.main.async {
            completion(userInfo)
        }
    }
}

func getUserFromDocument(uid: String, document : [String : Any]) -> UserModel{
    
    var username = ""
    var pic = ""
    var bio = ""
    var followerUsers = [String : [String]]()
    var followingUsers = [String : [String]]()
    var posts = 0
    var follower = 0
    var following = 0
    var real_name = ""
    var myHobbies = [String]()
    
    if document["username"] != nil{
        username = document["username"] as! String
    }
    
    if document["imageurl"] != nil{
        pic = document["imageurl"] as! String
    }
    
    if document["bio"] != nil{
        bio = document["bio"] as! String
    }
    
    if document["followingUsers"] != nil{
        followingUsers = document["followingUsers"] as! [String : [String]]
    }
    
    if document["followerUsers"] != nil{
        followerUsers = document["followerUsers"] as! [String : [String]]
    }
    
    if document["posts"] != nil{
        posts = document["posts"] as! Int
    }
    
    if document["follower"] != nil {
        follower = document["follower"] as! Int
    }
    
    if document["following"] != nil {
        following = document["following"] as! Int
    }
    
    if document["real_name"] != nil {
        real_name = document["real_name"] as! String
    }
    
    if document["myHobbies"] != nil {
        myHobbies = document["myHobbies"] as! [String]
    }
    //print("name of hobbit", name)
    //print("url of hobbit", url)
    // getting user Data...
    
    return UserModel(username: username, real_name: real_name, imageurl: pic, bio: bio, uid: uid, follower: follower, following: following, posts: posts, followerUsers: followerUsers, followingUsers: followingUsers, requests: [Request](), myHobbies: myHobbies)
}
