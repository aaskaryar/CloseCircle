//
//  SettingViewModel.swift
//  ShadeInc
//
//  Created by Randi Gjoni on 4/1/22.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase

class SettingViewModel : ObservableObject{
    
    @Published var current_uid = ""
    
    @Published var userInfo = UserModel.emptyUserModel
    
    @Published var picker = false
    @Published var img_data = Data(count: 0)
    @Published var isLoading = false
    @Published var swap = false;
    
    
    let uid = Auth.auth().currentUser!.uid

    let ref = Firestore.firestore()
    public let database = Database.database().reference()
    
    init(userInfo : UserModel) {
        
        self.userInfo = userInfo
        self.current_uid = userInfo.uid
    }
    
    func updateUserInfo(userInfo: UserModel){
        self.userInfo = userInfo
    }
    
    func updateImage()
    {
        isLoading = true
        //print("called")
        UploadImage(imageData: img_data, path: "profile_Photos") { (url) in
            
            self.ref.collection("Users").document(self.uid).updateData([
                "imageurl": url,
            ]) { (err) in
                if err != nil{
                    //print(err)
                    return}
                
                // Updating View..
                //print("WE HAVE BEEN CALLED")
                //print("THE IMAGE URL IS " + url)
                self.isLoading = false
                self.swap = true
                fetchUser(uid:self.uid) { (user) in
                    self.userInfo = user
                }
            }
        }
    }
    
    func updateDetails()
    {
        self.userInfo.bio = "In Progress"
    }
    
    func updateUser(type: String, value: String){
        
        isLoading = true
        
        var key = ""
        
        if(type == "Full Name"){
            key = "real_name"
        }
        
        if(type == "bio"){
            key = "bio"
        }
        
        ref.collection("Users").document(uid).updateData([
            key: value
        ]) { (err) in
            if err != nil{
                //print(err)
                return
                
            }
            
            // Updating View..
            self.isLoading = false
            self.swap = true
            fetchUser(uid:self.uid) { (user) in
                self.userInfo = user
            }
            
        }
    }
    
    
    func reportBug(bug: String){
        
        isLoading = true
        
        ref.collection("Bugs").document().setData([
        
            "bug": bug,
            "time": Date(),
            "uid": userInfo.uid,
            "username": userInfo.username
            
        ]){ (err) in
            
            if err != nil{
                self.isLoading = false
                return
            }
            
            self.isLoading = false
            // closing View When Succssfuly Posted...
        }
        
    }
    
}
