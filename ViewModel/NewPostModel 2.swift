//
//  NewPostView.swift
//  ShadeInc
//
//  Created by Randi Gjoni on 4/10/22.
//

import SwiftUI
import Firebase

class NewPostModel : ObservableObject{
    
    @Published var postTxt = ""
    @Published var postHobby = ""
    @Published var picker = false
    @Published var img_Data = Data(count: 0)
    let realtime_ref = Database.database().reference()
    @Published var isPosting = false
    @Published var tagedPeople = [UserModel]()
    
    private let encoder = JSONEncoder()
    
    let uid = Auth.auth().currentUser!.uid
    
    func post(card: CardModel){
        
        if(img_Data.isEmpty){
            let alert = UIAlertController(title:"Error", message: "No Photo Selected", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Ok",style: .default))
            UIApplication.shared.windows.first?.rootViewController?.present(alert,animated: true)
            return
        }
        
        isPosting = true
        
        var card = card
        
        if(!tagedPeople.isEmpty){
            
            var taggedPeopleUid = [String]()
            
            for user in tagedPeople{
                taggedPeopleUid.append(user.uid)
            }
            card.taggedPeople = taggedPeopleUid
            
        }
        
        UploadImage(imageData: img_Data, path: "post_Pics") { (url) in
            
            do {
                
                card.image = url
                let data = try self.encoder.encode(card)

                let json = try JSONSerialization.jsonObject(with: data)

                // 6
                self.realtime_ref.child("Posts").child(card.hobby_id).childByAutoId().setValue(json){
                    (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    } else {
                        print("Data saved successfully!")
                        let alert = UIAlertController(title:"Success", message: "Post Successfully", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title:"Ok",style: .default))
                        UIApplication.shared.windows.first?.rootViewController?.present(alert,animated: true)
                    }
                    self.isPosting = false
                  }
                
              }catch{
                  print("an error occurred", error)
                  self.isPosting = false
              }
            
            self.tagedPeople.removeAll()
            
        }
        
        
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
