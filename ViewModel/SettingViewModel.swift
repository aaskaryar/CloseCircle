//
//  SettingViewModel.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/1/22.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase

class SettingViewModel : ObservableObject{
    
    var current_uid = ""
    var userInfo = UserModel.emptyUserModel
    var editProfileAlertInfo : AlertInfo?
    var img_data = Data(count: 0)
    
    @Published var picker = false
    @Published var isLoading = false
    //@Published var swap = false;
    
    
    let uid = auth.currentUser!.uid
    //aria added
    public let database = Database.database(url: "https://shades-3b5b7-default-rtdb.firebaseio.com/").reference()
    
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
        print("updateImage called")
        UploadImage(id: userInfo.uid, imageData: img_data, path: "profile_Photos") { result in
            
            if let error = result.error{
                self.isLoading = false
                self.editProfileAlertInfo = AlertInfo(Title: "Failed", Message: error)
                return
            }
            
            guard let url = result.url else{
                self.isLoading = false
                self.editProfileAlertInfo = AlertInfo(Title: "Failed", Message: "Error: Empty URL")
                return
            }
            
            ref.collection("Users").document(self.uid).updateData([
                "imageurl": url,
            ]) { (err) in
                
                if let error = err{
                    self.isLoading = false
                    self.editProfileAlertInfo = AlertInfo(Title: "Failed", Message: error.localizedDescription)
                    return
                }
                
                self.isLoading = false
                self.editProfileAlertInfo = AlertInfo(Title: "Success", Message: "Upload Image Successfully")
                //self.swap = true
                fetchUser(uid:self.uid) { (user) in
                    guard let user = user else {return}
                    self.userInfo = user
                }
            }
        }
    }
    
    func updateDetails()
    {
        self.userInfo.bio = "In Progress"
    }
    
    func updateRealName(value: String){
        isLoading = true
        ref.collection("Users").document(uid).updateData([
            "real_name": value
        ]) { (err) in
            
            if let err = err{
                self.editProfileAlertInfo = AlertInfo(Title: "Error", Message: err.localizedDescription)
                self.isLoading = false
                return
            }
            
            // Updating View..
            self.isLoading = false
            self.editProfileAlertInfo = AlertInfo(Title: "Success", Message: "Change Real Name Successfully")
            //self.swap = true
            self.userInfo.real_name = value
        }
    }
    
    
    func updateUserName(value: String){
        isLoading = true
        let username = value
        ref.collection("Users").whereField("username", isEqualTo: username).getDocuments() { (querySnapshot, err) in
            //print("What????")
            if let err = err {
                self.editProfileAlertInfo = AlertInfo(Title: "Error", Message: err.localizedDescription)
                self.isLoading = false
            } else {
                                        
                guard let snapshot = querySnapshot else{
                    self.editProfileAlertInfo = AlertInfo(Title: "Error", Message: "Empty snapShot")
                    self.isLoading = false
                    return
                }
                
                if snapshot.documents.count == 0 {
                    ref.collection("Users").document(self.uid).updateData([
                        "username": username,
                    ]) { (err) in
                        
                        if let error = err{
                            self.isLoading = false
                            self.editProfileAlertInfo = AlertInfo(Title: "Failed", Message: error.localizedDescription)
                            return
                        }
                        
                        self.isLoading = false
                        self.editProfileAlertInfo = AlertInfo(Title: "Success", Message: "Change Username Successfully")
                        //self.swap = true
                        self.userInfo.username = username
                    }
                }else{
                    self.editProfileAlertInfo = AlertInfo(Title: "Error", Message: "username already taken")
                    self.isLoading = false
                    return
                }
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
