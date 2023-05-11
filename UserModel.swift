//
//  UserModel.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/1/22.
//

import SwiftUI
    
struct UserModel : Hashable, Codable, Identifiable {
    
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        lhs.uid == rhs.uid
    }
    
    static let emptyUserModel : UserModel = UserModel(username: "", real_name: "", imageurl: "", bio: "", uid: "", follower: 0, following: 0, posts: 0, followerUsers: [String : [String]](), followingUsers: [String :[String]](), requests: [Request](), myHobbies: [])
    
    var id = UUID()
    
    var username : String
    var real_name : String
    var imageurl : String
    var bio : String
    var uid : String
    var follower: Int
    var following: Int
    var posts: Int
    var followerUsers : [String : [String]]
    var followingUsers : [String : [String]]
    var requests : [Request]
    var myHobbies : [String]
}

