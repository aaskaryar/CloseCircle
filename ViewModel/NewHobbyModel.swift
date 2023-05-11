//
//  NewPostView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/10/22.
//

import SwiftUI
import Firebase

class NewHobbyModel : ObservableObject{
    
    @Published var hobbyName = ""
    @Published var hobbyPrivate = ""
    @Published var picker = false
    @Published var img_Data = Data(count: 0)
    
    @Published var isPosting = false
    
    var newHobbyAlertInfo : AlertInfo?
    var editHobbyAlertInfo : AlertInfo?
    
    
    let uid = auth.currentUser!.uid
    
    func createHobby(present : Binding<PresentationMode>){
        
        isPosting = true
        
        print(img_Data.count)
        print(self.hobbyName)
        print(self.hobbyPrivate)
        
        hobbyPrivate = hobbyPrivate == "" ? Constants.Private : hobbyPrivate
        
        let DocRef = ref.collection("Users").document(uid).collection("Hobbies").document()
        // ref is a DocumentReference
        let id = DocRef.documentID
        if img_Data.count == 0{
            
            DocRef.setData([
                "name": self.hobbyName,
                "privacy": self.hobbyPrivate,
                "url" : "https://firebasestorage.googleapis.com/v0/b/shade-inc.appspot.com/o/default.jpg?alt=media&token=d70bfdc3-46ac-4744-912b-8e29e08eebdc",
                "followers": [],
                "categories": [],
                ]){ (err) in
                    
                    self.isPosting = false
                    if err != nil{return}
                    
                    present.wrappedValue.dismiss()
                    ref.collection("Users").document(self.uid).updateData([
                        "myHobbies": FieldValue.arrayUnion([id])
                    ])
                }
        
        }
        else{
            UploadImage(id: DocRef.documentID, imageData: img_Data, path: "hobby_Pics") { result in
                
                if let error = result.error{
                    self.isPosting = false
                    self.newHobbyAlertInfo = AlertInfo(Title: "Failed", Message: error)
                    return
                }
                
                guard let url = result.url else{
                    self.isPosting = false
                    self.newHobbyAlertInfo = AlertInfo(Title: "Failed", Message: "Error: Empty URL")
                    return
                }
                
                DocRef.setData([
                        "name": self.hobbyName,
                        "privacy": self.hobbyPrivate,
                        "url" : url,
                        "followers": [],
                        "categories": [],
                    ]){ (err) in
                        
                        self.isPosting = false
                        if let error = err {
                            self.newHobbyAlertInfo = AlertInfo(Title: "Failed", Message: error.localizedDescription)
                            return
                        }
                        
                        //present.wrappedValue.dismiss()
                        self.newHobbyAlertInfo = AlertInfo(Title: "Success", Message: "Hobby Created Successfully")
                        ref.collection("Users").document(self.uid).updateData([
                            "myHobbies": FieldValue.arrayUnion([id])
                        ])
                    }
            }
        }
        
        
    }
    
    func editHobby(hobby: HobbyModel){
        
        isPosting = true
        
        var hobby = hobby
        
        hobby.name = hobbyName
        hobby.privacy = hobbyPrivate
        updateHobbyDic(hid: hobby.id, hobby: hobby)
        ref.collection("Users").document(hobby.uid).collection("Hobbies").document(hobby.id).updateData([
            "name" : hobbyName,
            "privacy" : hobbyPrivate
        ])
        
        if img_Data.count != 0{
            
            UploadImage(id: hobby.id, imageData: img_Data, path: "hobby_Pics") { result in
                
                if let error = result.error{
                    self.isPosting = false
                    self.editHobbyAlertInfo = AlertInfo(Title: "Failed", Message: error)
                    return
                }
                
                guard let url = result.url else{
                    self.isPosting = false
                    self.editHobbyAlertInfo = AlertInfo(Title: "Failed", Message: "Error: Empty URL")
                    return
                }
                
                ref.collection("Users").document(hobby.uid).collection("Hobbies").document(hobby.id).updateData([
                    "url" : url,
                ])
                
                self.isPosting = false
                self.editHobbyAlertSuccess()
            }
            
        }else{
            
            self.isPosting = false
            self.editHobbyAlertSuccess()
        }
    }
    
    func editHobbyAlertSuccess(){
        editHobbyAlertInfo = AlertInfo(Title: "Edit Success", Message: "")
    }
}
