//
//  NewPostView.swift
//  ShadeInc
//
//  Created by Randi Gjoni on 4/10/22.
//

import SwiftUI
import Firebase

class NewHobbyModel : ObservableObject{
    
    @Published var hobbyName = ""
    @Published var hobbyPrivate = ""
    @Published var picker = false
    @Published var img_Data = Data(count: 0)
    
    @Published var isPosting = false
    
    
    let uid = Auth.auth().currentUser!.uid
    
    func createHobby(present : Binding<PresentationMode>){
        
        isPosting = true
        
        print(img_Data.count)
        print(self.hobbyName)
        print(self.hobbyPrivate)
        
        let DocRef = ref.collection("Users").document(uid).collection("Hobbies").document()
        // ref is a DocumentReference
        let id = DocRef.documentID
        if img_Data.count == 0{
            
            DocRef.setData([
                "name": self.hobbyName,
                "privacy": self.hobbyPrivate,
                "url" : "",
                "followers": [],
                "categories": [],
                ]){ (err) in
                    
                    self.isPosting = false
                    if err != nil{return}
                    
                    present.wrappedValue.dismiss()
                }
        
        }
        else{
            UploadImage(imageData: img_Data, path: "hobby_Pics") { (url) in
                
                DocRef.setData([
                        "name": self.hobbyName,
                        "privacy": self.hobbyPrivate,
                        "url" : url,
                        "followers": [],
                        "categories": [],
                    ]){ (err) in
                        
                        self.isPosting = false
                        if err != nil{return}
                        
                        present.wrappedValue.dismiss()
                    }
            }
        }
        ref.collection("Users").document(uid).updateData([
            "myHobbies": FieldValue.arrayUnion([id])
        ])
        
    }
    
    func delete_post(id: String){
         
        ref.collection("Posts").document(id).delete { (err) in
            if (err  != nil){
                print(err!.localizedDescription)
                return
            }
        }
    }
    
}
