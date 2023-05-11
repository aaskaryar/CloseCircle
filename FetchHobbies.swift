//
//  FetchHobbies.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 5/24/22.
//

import SwiftUI
import Firebase

private var hobbyDic : [String: HobbyModel] = [String: HobbyModel]()
private var hobbyTimer : [String : Date] = [String : Date]()

func updateHobbyDic(hid: String, hobby: HobbyModel?){
    hobbyDic[hid] = hobby
}

func fetchHobby(uid: String, hid: String, refresh: Bool, completion: @escaping (HobbyModel?) -> ()){
    
    
    if !refresh{
        if let hobby = hobbyDic[hid]{
            DispatchQueue.main.async {
                completion(hobby)
            }
            return
        }
    }
    
    if let lastQuery = hobbyTimer[hid]{
        
        if Date.now <= lastQuery.addingTimeInterval(1){
            
            if let hobby = hobbyDic[hid]{
                
                DispatchQueue.main.async {
                    completion(hobby)
                }
                return
            }
        }
        
    }
    
    print("Fetching \(uid)'s \(hid)")
    
    ref.collection("Users").document(uid).collection("Hobbies").document(hid).getDocument{ (snap, err) in
        guard let doc = snap else{
            return
        }
        
        guard let document = doc.data() else {
            completion(nil)
            return
        }
        
        let hobby = getHobbyFromDocument(uid: uid, id: doc.documentID, document: document)
        
        hobbyDic[hid] = hobby
        hobbyTimer[hid] = Date.now
        
        DispatchQueue.main.async {
            completion(hobby)
        }
    }
}

func ListenOnHobbiesChange(uid: String,completion: @escaping ([HobbyModel]) -> ()) -> ListenerRegistration{
    
    var hobbies = [String : HobbyModel]()
    
    print(auth)
    
    return ref.collection("Users").document(uid).collection("Hobbies").addSnapshotListener{ (snap, err) in
        guard let docs = snap else{
            DispatchQueue.main.async {
                completion(hobbies.map({$0.value}))
            }
            return
        }
        
        if docs.documentChanges.isEmpty{
            DispatchQueue.main.async {
                completion(hobbies.map({$0.value}))
            }
            return
        }
        
        print("hobby Document change: ", docs.documentChanges)
        
        docs.documentChanges.forEach { (doc) in
            
            if doc.type == .removed {
                hobbies[doc.document.documentID] = nil
                hobbyDic[doc.document.documentID] = nil
            }else{
                
                let hobby = getHobbyFromDocument(uid: uid, id: doc.document.documentID, document: doc.document.data())
                
                hobbies[hobby.id] = hobby
                hobbyDic[hobby.id] = hobby
            }
        }
        
        print("Current Hobbies: ", hobbies)
        
        DispatchQueue.main.async {
            completion(hobbies.map({$0.value}))
        }
    }
}

func getHobbyFromDocument(uid: String, id: String, document : [String : Any]) -> HobbyModel{
    
    var url = ""
    var followers = [String]()
    var pendingFollowers = [String]()
    var name = ""
    var privacy = " "
    var categories = [String]()
    // Retreving And Appending...
    
    if document["name"] != nil{
        name = document["name"] as! String
    }
    
    if document["pendingFollowers"] != nil{
        pendingFollowers = document["pendingFollowers"] as! [String]
    }
    
    if document["url"] != nil{
        url = document["url"] as! String
    }
    if document["followers"] != nil{
        followers = document["followers"] as! [String]
    }
   
    if(document["privacy"] != nil)
    {
        privacy = document["privacy"] as! String
    }
    
    
    if(document["categories"] != nil)
    {
        categories = document["categories"] as! [String]
    }
    //print("name of hobbit", name)
    //print("url of hobbit", url)
    // getting user Data...
    
    return HobbyModel(id: id, name: name, url: url, privacy: privacy, uid: uid, followers: followers, pendingFollowers: pendingFollowers, categories: categories)
}
