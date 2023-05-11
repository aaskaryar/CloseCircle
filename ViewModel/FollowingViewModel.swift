//
//  FollowingViewModel.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 5/22/22.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase

class FollowingViewModel: ObservableObject {
    
    @Published var userInfo : UserModel
    @Published var followingHobbyNameDic : [String : [String]] = [String : [String]]()
    @Published var followingUids : [String] = [String]() //
    @Published var hobbySet : [String: Int] = [String: Int]() // used to present the top scoll bar
    //@Published var followingDic = [UserModel : [HobbyModel]]();
    var followingUserDic = [String : UserModel]()
    //@Published var followingHobbyDic = [String : [HobbyModel]]()
    
    var followingHobbyIdDic : [String : [String]] = [String : [String]]()
    
    var hobbyMap : [String : String] = [String: String]() // simply map each hobbyid to name
    var Change = false
    
    public var CurrentlyGetFollowingUserNum : Int = 0
    
//    private var UserListenersDic : [String : ListenerRegistration] = [String : ListenerRegistration]()
//
//    private var HobbiesListenersDic : [String : []]
    
    let ref = Firestore.firestore()
    
    init(userInfo : UserModel){
        self.userInfo = userInfo
        print("init followingViewModel")
        getMoreFollowings(size: 10)
    }
    
    func updateUserInfo(userInfo: UserModel){
        print("FollowingViewModel updating")
        
        //
        // Why this big update is necessary
        // in thie followingviewmodel, when unfollowing people's hobby
        // it will go to that user's profile and delete the uid
        
        // same, if some user make us unfollow their hobby in their follower page
        // we can feel it here, thus need to update
        //
        // Don't care about new user, it's refresh's job
        // just delete the old that no longer following
        //
        
        let newInfo = userInfo
        let user = self.userInfo
        
        var newFollowers = newInfo.followingUsers
        
        if(newInfo.followingUsers.isEmpty){ // I no longer follow anyone
            followingUserDic = [String : UserModel]()
            //@Published var followingHobbyDic = [String : [HobbyModel]]()
            followingHobbyNameDic = [String : [String]]()
            followingHobbyIdDic = [String : [String]]()
            followingUids = [String]() //
            hobbySet = [String: Int]() //
            hobbyMap = [String: String]()
        }
        
        // iterate through to check
        for (followingUid, hobbyArray) in user.followingUsers{
            
            if(newInfo.followingUsers[followingUid] == nil){
                // if you no long follow some one, this is nil in the new one
                deleteFollowingUser(followingUid: followingUid)
            }else{
                // not a new user, check if there is new hobby inside
                
                newFollowers = newFollowers.filter{$0.key != followingUid}
                
                var oldHobbyArray : [String] = hobbyArray
                var newHobbyArray : [String] = newInfo.followingUsers[followingUid]!
                
                // iterate through to delete the hobby that's in both array
                // what's left in oldHobbyArray need to be deleted
                // what's left in newHobbyArray need to be added
                for (oldHobbyId) in user.followingUsers[followingUid]!{
                    
                    if(newHobbyArray.contains(oldHobbyId)){ // if still there, leave
                        oldHobbyArray = oldHobbyArray.filter{$0 != oldHobbyId}
                        newHobbyArray = newHobbyArray.filter{$0 != oldHobbyId}
                    }
                    
                }
                
                // only care about old hobby to delete
                for hobbyId in oldHobbyArray{
                    deleteFollowingHobby(followingUid: followingUid, hobbyId: hobbyId)
                }
                
                for hobbyId in newHobbyArray{
                    addFollowingHobby(followingUid: followingUid, hobbyId: hobbyId)
                }
            }
            
        }
        
        self.userInfo = userInfo
        
        for (followingUid, _) in newFollowers{
            
            fetchUser(uid: followingUid){ user in
                guard let user = user else {return}
                self.addFollowingUser(followingInfo: user)
            }
        }

        //refreshFollowing(size: 6)
    }
    
    func addFollowingUser(followingInfo: UserModel){
        
        let followingUid = followingInfo.uid
        
        self.followingUserDic[followingUid] = followingInfo
        
        self.followingUids.append(followingUid)
        
        guard let followingHobbyIds = self.userInfo.followingUsers[followingUid] else{
            print("Empty hobby list, panic")
            return
        }
        
        for hobbyId in followingHobbyIds{
            
            addFollowingHobby(followingUid: followingUid, hobbyId: hobbyId)
        }
    }
    
    func addFollowingHobby(followingUid: String, hobbyId: String){
        
        fetchHobby(uid: followingUid, hid: hobbyId, refresh: true){ (hobby) in
            
            guard let hobby = hobby else {
                print("hobby not found from db")
                return
            }
            
            if(self.followingHobbyNameDic[followingUid] == nil){
                self.followingHobbyNameDic[followingUid] = [String]()
            }
            if(self.followingHobbyIdDic[followingUid] == nil){
                self.followingHobbyIdDic[followingUid] = [String]()
            }
            self.followingHobbyIdDic[followingUid]?.append(hobby.id)
            self.hobbyMap[hobby.id] = hobby.name
            if(self.hobbySet[hobby.name] == nil){
                self.hobbySet[hobby.name] = 0
            }
            self.hobbySet[hobby.name]! += 1
            //self.followingDic[user]?.append(hobby)
            //self.followingHobbyDic[user.uid]?.append(hobby)
            self.followingHobbyNameDic[followingUid]?.append(hobby.name)
            
        }
    }
    
    func deleteFollowingUser(followingUid: String){
        
        var hobbyToDelete = [String]()
        if(followingHobbyIdDic[followingUid] != nil){
            hobbyToDelete = followingHobbyIdDic[followingUid]!
        }
        followingUserDic[followingUid] = nil
        followingHobbyNameDic[followingUid] = nil
        followingHobbyIdDic[followingUid] = nil
        followingUids = followingUids.filter{ $0 != followingUid }
        for hobbyId in hobbyToDelete{
            
            if let hobbyName = self.hobbyMap[hobbyId] {
                hobbySet[hobbyName]! -= 1
                if(hobbySet[hobbyName] == 0){
                    hobbySet[hobbyName] = nil
                }
                hobbyMap[hobbyId] = nil
            }
        }
    }
    
    func deleteFollowingHobby(followingUid: String, hobbyId: String){
        if let hobbyName = self.hobbyMap[hobbyId] {
            self.followingHobbyNameDic[followingUid] = self.followingHobbyNameDic[followingUid]!.filter{$0 != hobbyName}
            self.hobbySet[hobbyName]! -= 1
            if(self.hobbySet[hobbyName] == 0){
                self.hobbySet[hobbyName] = nil
            }
        }
        self.followingHobbyIdDic[followingUid] = self.followingHobbyIdDic[followingUid]!.filter{$0 != hobbyId}
            self.hobbyMap[hobbyId] = nil
    }
    
    func getMoreFollowings(size: Int){
        
        let followings = userInfo.followingUsers
        
        var lastIndex = self.CurrentlyGetFollowingUserNum
        
        let followingUids = followings.map{$0.key}
        
        for (index, followingUid) in followingUids.enumerated(){
            
            if followingUids.count == self.CurrentlyGetFollowingUserNum {
                break
            }
            
            if index >= self.CurrentlyGetFollowingUserNum && index < self.CurrentlyGetFollowingUserNum + size{
                
                lastIndex += 1
                
                fetchUser(uid: followingUid){ user in
                    guard let user = user else {return}
                    self.addFollowingUser(followingInfo: user)
                }
            }
            
            self.CurrentlyGetFollowingUserNum = lastIndex
            print(self.CurrentlyGetFollowingUserNum)
        }
    }
    
    func refreshFollowingOld(size: Int){
        
        var followings = userInfo.followingUsers.map { $0.key }
        //print(followings)
                
        for userId in followingUids{

            if let index = followings.firstIndex(of: userId) {
                followings.remove(at: index)
            }

        }
        
        if(followings.isEmpty){
            return
        }
        
        followings = Array(followings[0...min(followings.count-1, size - 1)])
        
        for uid in followings{
            
            fetchUser(uid: uid){ (userInfo) in
                guard let userInfo = userInfo else {return}
                
                self.followingUserDic[uid] = userInfo
                self.followingUids.append(uid)
                
                for hobbyId in self.userInfo.followingUsers[uid]!{
                    
                    fetchHobby(uid: uid, hid: hobbyId, refresh: true){ (hobby) in
                        guard let hobby = hobby else {
                            print("hobby not found from db")
                            return
                        }
                        
                        if(self.followingHobbyNameDic[uid] == nil){
                            self.followingHobbyNameDic[uid] = [String]()
                        }
                        if(self.followingHobbyIdDic[uid] == nil){
                            self.followingHobbyIdDic[uid] = [String]()
                        }
                        self.followingHobbyIdDic[uid]?.append(hobby.id)
                        self.hobbyMap[hobby.id] = hobby.name
                        if(self.hobbySet[hobby.name] == nil){
                            self.hobbySet[hobby.name] = 0
                        }
                        self.hobbySet[hobby.name]! += 1
                        //self.followingDic[user]?.append(hobby)
                        //self.followingHobbyDic[user.uid]?.append(hobby)
                        self.followingHobbyNameDic[uid]?.append(hobby.name)
                        
                    }
                }
            }
            
            
        }
    }
    
//    func refreshFollowing(){
//
//        for (followingUid, followingHobbies) in followingHobbyIdDic{
//
//        }
//    }
    
    func unfollowPeople(uid: String){
        
        ref.collection("Users").document(userInfo.uid).updateData([
            "followingUsers.\(uid)": FieldValue.delete(),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func unfollowHobby(uid: String, HobbyId: String){
        
        let hobbyName : String = hobbyMap[HobbyId]!
        
        let delete : Bool = self.followingHobbyIdDic[uid]!.count == 1
        
        unfollowHobbyInFirestore(myUid: userInfo.uid, hobbyOwnerUid: uid, hobbyId: HobbyId, delete: delete)
    }
        
                        
//        ]) { err in
//            if let err = err {
//                print("Error updating document: \(err)")
//            } else {
//                print("Document successfully updated")
//                self.ref.collection("Users").document(uid).collection("Hobbies").document(HobbyId).updateData([
//                    "followers" : FieldValue.arrayRemove([self.userInfo.uid])
//                ])
//                self.ref.collection("Users").document(uid).updateData([
//                    "followerUsers" : FieldValue.arrayRemove([self.userInfo.uid])
//                ])
//                self.followingHobbyNameDic[uid] = self.followingHobbyNameDic[uid]!.filter{$0 != hobbyName}
//                self.followingHobbyIdDic[uid] = self.followingHobbyIdDic[uid]!.filter{$0 != HobbyId}
//                if(self.followingHobbyNameDic[uid]!.isEmpty){ // if unfollowing last
//                    self.followingHobbyNameDic[uid] = nil
//                    self.followingHobbyIdDic[uid] = nil
//                    self.ref.collection("Users").document(self.userInfo.uid).updateData([
//                        "followingUsers.\(uid)": FieldValue.delete(),
//                    ])
//                }
//                self.hobbyMap[HobbyId] = nil
//                self.hobbySet[hobbyName]! -= 1
//                if(self.hobbySet[hobbyName] == 0){
//                    self.hobbySet[hobbyName] = nil
//                }
//            }
//        }
}

func unfollowHobbyInFirestore(myUid : String, hobbyOwnerUid: String, hobbyId: String, delete: Bool){
    ref.collection("Users").document(myUid).updateData(
        delete ? ["followingUsers.\(hobbyOwnerUid)": FieldValue.delete()] : ["followingUsers.\(hobbyOwnerUid)": FieldValue.arrayRemove([hobbyId])]
    )
    
    ref.collection("Users").document(hobbyOwnerUid).collection("Hobbies").document(hobbyId).updateData([
        "followers" : FieldValue.arrayRemove([myUid])
    ])
    ref.collection("Users").document(hobbyOwnerUid).updateData(
        delete ? ["followerUsers.\(myUid)" : FieldValue.delete()] : ["followerUsers.\(myUid)" : FieldValue.arrayRemove([hobbyId])]
    )
}
