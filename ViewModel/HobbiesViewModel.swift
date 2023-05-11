//
//  HobbiesViewModel.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/10/22.
//

import SwiftUI
import Firebase

class HobbiesViewModel : ObservableObject{
    
    var noHobbies = false
    @Published var newHobby = false
    @Published var hobbies : [HobbyModel] = []
    @Published var hobbiesDic : [String : HobbyModel] = [String : HobbyModel]()
    @Published var hobbiesOptions : [DropdownOption] = []
    @Published var editing = false
    var detail = false
    @Published var isLoading = false
    @Published var hobbyOnDetail : HobbyModel = HobbyModel(id: "", name: "", url: "", privacy: "", uid: "", followers: [], categories: [])
    @Published var userInfo : UserModel
    @Published var selectedHobby : HobbyModel  = HobbyModel(id: "", name: "", url: "", privacy: "", uid: "", followers: [], categories: [])
    @Published var isEditing : Bool = false
    
    //var current_uid = ""
    let uid = auth.currentUser!.uid
    
    init(userInfo : UserModel) {
        self.userInfo = userInfo
        //self.current_uid = userInfo.uid
        //print("Here", self.current_uid)
        //getAllHobbies()
    }
    
    func updateUserInfo(userInfo: UserModel){
        self.userInfo = userInfo
    }
    
    func updateHobbies(newHobbies : [HobbyModel]){
        
        hobbies = newHobbies
        if hobbies.isEmpty{
            noHobbies = true
        }
        
        for hobby in hobbies{
            hobbiesDic[hobby.id] = hobby
        }
        
        
        self.hobbies = self.hobbies.sorted(by: { first, second in
            first.id > second.id
        })
//        if(hobbies.isEmpty){
//            hobbies = newHobbies
//        }else{
//
//        }
        if hobbies.contains(where: { hobby in
            hobby.id == hobbyOnDetail.id
        }){
            hobbyOnDetail = hobbies.filter{$0.id == hobbyOnDetail.id}[0]
            print("update hobbyOnDetail \(hobbyOnDetail.name)")
        }
        
        print("new Hobbies: ", hobbies)
    }
    
    func deleteHobby(id: String){
        
        ref.collection("Users").document(uid).collection("Hobbies").document(id).delete { (err) in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
            for (followerUid, hobbyIds) in self.userInfo.followerUsers{
                
                for hobbyId in hobbyIds{
                    
                    if hobbyId == id{
                        
                        let delete : Bool = hobbyIds.count == 1
                        
                        unfollowHobbyInFirestore(myUid: followerUid, hobbyOwnerUid: self.uid, hobbyId: hobbyId, delete: delete)
                    }
                }
            }
            
            
            ref.collection("Users").document(self.uid).updateData([
                "myHobbies": FieldValue.arrayRemove([id]),
            ])
            
//            fetchHobbyPostList(hobbyId: id) { postList in
//                guard let postList = postList else {
//                    print("hobbyPostList not found from db")
//                    return
//                }
//                
//                for (postId, _) in postList{
//                    realtime_ref.child("Posts").child(postId).removeValue()
//                }
//                realtime_ref.child("HobbyPostLists").child(id).removeValue()
//            }
        }
    }
    
    func addCategories(id: String, tag: String){
        
        isLoading = true
        
        ref.collection("Users").document(uid).collection("Hobbies").document(id).updateData([
            "categories": FieldValue.arrayUnion([tag])
        ]){ (err) in
            if err != nil{
                print(err!.localizedDescription)
                self.isLoading = false
                return
            }
            
            if self.selectedHobby.categories == nil{
                self.selectedHobby.categories = [String]()
            }
            self.selectedHobby.categories?.append(tag)
            self.isLoading = false
        }
    }
    
    func updateHobbyPrivacy(privacy: String){
        ref.collection("Users").document(uid).collection("Hobbies").document(hobbyOnDetail.id).updateData([
            "privacy" : privacy
        ])
    }
}


//func getAllHobbies(){
//
//    ref.collection("Users").document(current_uid).collection("Hobbies").addSnapshotListener{ (snap, err) in
//        guard let docs = snap else{
//            self.noHobbies = true
//            return
//
//        }
//
//        if docs.documentChanges.isEmpty{
//
//            self.noHobbies = true
//            return
//        }
//
//        docs.documentChanges.forEach { (doc) in
//
//            // Checking If Doc Added...
//            if doc.type != .removed{
//
//                var url = ""
//                var followers = [String]()
//                // Retreving And Appending...
//                let name = doc.document.data()["name"] as! String
//                if doc.document.data()["url"] != nil{
//                    url = doc.document.data()["url"] as! String
//
//                }
//                if doc.document.data()["followers"] != nil{
//                    followers = doc.document.data()["followers"] as! [String]
//
//                }
//                var privacy = " "
//                if(doc.document.data()["privacy"] != nil)
//                {
//                    privacy = doc.document.data()["privacy"] as! String
//                }
//
//                var categories = [String]()
//                if(doc.document.data()["categories"] != nil)
//                {
//                    categories = doc.document.data()["categories"] as! [String]
//                }
//                //print("name of hobbit", name)
//                //print("url of hobbit", url)
//                // getting user Data...
//
//                let hobby = HobbyModel(id: doc.document.documentID, name: name, url: url, privacy: privacy, uid: self.current_uid, followers: followers, categories: categories)
//
//                if doc.type == .added{
//                    self.hobbies.append(hobby)
//                    self.hobbiesOptions.append(DropdownOption(key: doc.document.documentID, value: name))
//                }else{
//                    let id = doc.document.documentID
//                    let index = self.hobbies.firstIndex { (hobby) -> Bool in
//                        return hobby.id == id
//                    } ?? -1
//
//                    if index != -1{
//
//                        self.hobbies[index] = hobby
//                    }
//                }
//            }
//
//            if doc.type == .removed{
//
//                let id = doc.document.documentID
//
//                self.hobbies.removeAll { (hobby) -> Bool in
//
//                    return hobby.id == id
//                }
//
//                if( self.hobbies.count == 0){
//                    self.noHobbies = true
//                }
//            }
//
//        }
//
//        print("Username: ", self.userInfo.username, "hobby number: ", self.hobbies.count)
//
//    }
//
//}
