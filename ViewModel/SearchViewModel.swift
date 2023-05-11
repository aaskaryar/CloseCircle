//
//  SearchViewModel.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/20/22.
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
        if searchText == "" {return}
        
        var searchText = searchText.lowercased()
        ref.collection("Users")
            .whereField("caseSearch", arrayContains: searchText)
            //.order(by: "posts")
            .limit(to: 6)
            .getDocuments(){ (querySnapshot, error) in
                
                do{
                    var usernames : [String] = Array()
                    var userInfos = [String: UserModel]()
                    var userIds = [String]()
                    
                    if let err = error {
                        print("Error getting documents: \(err)")
                    } else {
                        //print("food")
                        for document in querySnapshot!.documents {
                            
                            let userInfo = getUserFromDocument(uid: document.documentID, document: document.data())
                            
                            usernames.append(userInfo.username)
                            usernames.append(userInfo.real_name)
                            //print(username)
                            
                            userInfos[document.documentID] = userInfo
                            userIds.append(document.documentID)
                        }
                        
                        self.recommandtion_name = usernames
                        self.recommandtion = userInfos
                        self.recommandtionId = userIds
                    }
                }catch{
                    print(error)
                }
                
                
            }
//        
//        self.recommandtion_name = usernames
//        self.recommandtion = userInfos
//        print(self.recommandtion)
    }
}
