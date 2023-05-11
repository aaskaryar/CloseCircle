
//  FollowerViewModel.swift
//  ShadeInc
//
//  Created by Macbook on 5/24/22.


import SwiftUI


class FollowerViewModel: ObservableObject{

    @Published var userInfo : UserModel
    @Published var hobbies : [HobbyModel] = []
    // this is Dic [uid : userModel]
    @Published var Followers : [String : UserModel] = [String : UserModel]()
    // This is Dic [FollowerUid : [HobbyId]]
    @Published var FollowersHobbyIdDic : [String : [String]] = [String : [String]]()
    
    init(userInfo: UserModel){
        self.userInfo = userInfo
    }
    
    func updateUserInfo(userInfo: UserModel){
        print("FollowerViewModel updating UserInfo")
        self.userInfo = userInfo
    }
    
    func updateHobbies(newHobbies : [HobbyModel]){
        print("FollowerViewModel updating Hobbies")
        
        var newAddedHobbies : [HobbyModel] = newHobbies
        
        let oldHobbies = self.hobbies
        
        for hobby in oldHobbies{
            
            if(!newHobbies.contains(hobby)){ // means we removed this hobby
                
                let hobbyToRemove = hobby
                
                for (uid, hobbyIds) in self.FollowersHobbyIdDic{
                    
                    if(hobbyIds.contains(hobbyToRemove.id)){
                        self.FollowersHobbyIdDic[uid] = hobbyIds.filter{$0 != hobbyToRemove.id}
                    }
                    if(hobbyIds.isEmpty){
                        self.FollowersHobbyIdDic[uid] = nil
                    }
                }
            }
            else{
                // here is to delete and left only the newly added hobbies inside
                newAddedHobbies = newAddedHobbies.filter{ $0.id != hobby.id }
                
                // here we want to find out if someone followed or leaved
                var oldHobbyFollowers : [String] = hobby.followers
                var newHobbyFollowers : [String] = newHobbies.first(where: {$0.id == hobby.id})!.followers
                
                for oldFollower in oldHobbyFollowers{
                    
                    if(newHobbyFollowers.contains(oldFollower)){ // if still there, leave
                        oldHobbyFollowers = oldHobbyFollowers.filter{$0 != oldFollower}
                        newHobbyFollowers = newHobbyFollowers.filter{$0 != oldFollower}
                    }
                }
                
                // Same as what happened in PostViewModel's UserUpdate, what's left
                // in oldHobbyFollowers are no longer following this hobby
                
                for unFollowerId in oldHobbyFollowers{
                    if(self.FollowersHobbyIdDic[unFollowerId] != nil){
                        self.FollowersHobbyIdDic[unFollowerId] = self.FollowersHobbyIdDic[unFollowerId]!.filter{$0 != hobby.id}
                        if(self.FollowersHobbyIdDic[unFollowerId]!.isEmpty){
                            self.FollowersHobbyIdDic[unFollowerId] = nil
                            self.Followers[unFollowerId] = nil
                        }
                    }
                }
                
                for newFollowerId in newHobbyFollowers{
                    addFollowerIn(followerId: newFollowerId, hobbyId: hobby.id)
                }
            }
        }
        
        for newAddedHobby in newAddedHobbies {
            
            let followers = newAddedHobby.followers
            
            for follower in followers {
                
                addFollowerIn(followerId: follower, hobbyId: newAddedHobby.id)
            }
            
        }
                
        self.hobbies = newHobbies
    }
    
    func addFollowerIn(followerId: String, hobbyId: String){
        
        if(self.Followers[followerId] == nil){
            fetchUser(uid: followerId){ (user) in
                self.Followers[followerId] = user
            }
        }
        if(self.FollowersHobbyIdDic[followerId] == nil){
            self.FollowersHobbyIdDic[followerId] = [String]()
        }
        self.FollowersHobbyIdDic[followerId]!.append(hobbyId)
    }

    func refreshFollowers(size: Int, followersList : [String]){
        
        //var followersGoingToGet : [String] = userInfo.followerUsers
        
        var followersGoingToGet : [String] = [String]()
        
        for uid in Followers.map({$0.key}){
            followersGoingToGet = followersList.filter{$0 != uid}
        }
        
        if(followersGoingToGet.isEmpty){
            print("That's all the followers you got")
            return
        }
        
        followersGoingToGet = Array(followersGoingToGet[0...min(followersGoingToGet.count, size-1)])
        
        for uid in followersGoingToGet{
            
            fetchUser(uid: uid){ (user) in
                
                self.Followers[uid] = user
                
                self.FollowersHobbyIdDic[uid] = user.followingUsers[self.userInfo.uid]
            }
        }
    }
    
    func forceUnfollow(uid: String, hobbyId : String){
        
        unfollowHobbyInFirestore(myUid: uid, hobbyOwnerUid: userInfo.uid, hobbyId: hobbyId, delete: false)
    }
}
