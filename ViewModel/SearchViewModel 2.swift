//
//  SearchViewModel.swift
//  ShadeInc
//
//  Created by Macbook on 4/20/22.
//

import SwiftUI
import Firebase

class SearchViewModel: ObservableObject {
    
    //@Published var SearchText : String
    @AppStorage("show_tab_bar") var bar = true
    @Published var recommandtion : [String: UserModel]
    @Published var recommandtion_name: [String]
    @Published var recommandtionId : [String]
    
    init(){
        recommandtion = [String: UserModel]()
        recommandtionId = [String]()
        recommandtion_name = []
    }
    
    public func bar_on(){
        self.bar = true
    }
    
    public func bar_off(){
        self.bar = false
    }
    
    func search(searchText: String){
        //print (searchText, "received")
        var usernames : [String] = Array()
        var userInfos = [String: UserModel]()
        var userIds = [String]()
        ref.collection("Users")
            .whereField("caseSearch", arrayContains: searchText)
            //.order(by: "posts")
            .limit(to: 6)
            .getDocuments(){ (querySnapshot, error) in
                
                if let err = error {
                    print("Error getting documents: \(err)")
                } else {
                    //print("food")
                    for document in querySnapshot!.documents {
                        
                        var username = ""
                        var real_name = ""
                        var url = ""
                        var follower = 0
                        var following = 0
                        var posts = 0
                        var myHobbies = [String]()
                        //print(document.documentID)
                        
                        if document.data()["username"] != nil{
                            username = document.data()["username"] as! String
                        }
                        if document.data()["real_name"] != nil{
                            real_name = document.data()["real_name"] as! String
                        }
                        if document.data()["imageurl"] != nil{
                            url = document.data()["imageurl"] as! String
                        }
                        if document.data()["follower"] != nil{
                            follower = document.data()["follower"] as! Int
                        }
                        if document.data()["following"] != nil{
                            following = document.data()["following"] as! Int
                        }
                        if document.data()["url"] != nil{
                            posts = document.data()["posts"] as! Int
                        }
                        if(document.data()["myHobbies"] != nil){
                            myHobbies = document.data()["myHobbies"] as! [String]
                        }

                        
                        
                        let userInfo = UserModel(username: username, real_name: real_name, imageurl: url, bio: "", uid: document.documentID, follower: follower, following: following, posts: posts, followerUsers: [String](), followingUsers: [String:[String]](), requests: [Request](), myHobbies: myHobbies)
                        
                        usernames.append(username)
                        usernames.append(real_name)
                        //print(username)
                        
                        userInfos[document.documentID] = userInfo
                        userIds.append(document.documentID)
                    }
                    
                    self.recommandtion_name = usernames
                    self.recommandtion = userInfos
                    self.recommandtionId = userIds
                }
            }
//        
//        self.recommandtion_name = usernames
//        self.recommandtion = userInfos
//        print(self.recommandtion)
    }
}
