//
//  NewPostView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/10/22.
//

import SwiftUI
import Firebase

class NewPostModel : ObservableObject{
    
    @Published var picker = false    
    @Published var isPosting = false
    @Published var tagedPeople = [UserModel]()
    @Published var showEditView: Bool = false
    
    @Published var newAlertInfo : AlertInfo?
    @Published var forwardAlertInfo : AlertInfo?
    @Published var result : imagePickingResult = imagePickingResult()
    @Published var img_Data = Data(count: 0)
    @Published var postProgress = 0.0
    private let encoder = JSONEncoder()
    let uid = auth.currentUser!.uid
    var userInfo : UserModel?
    
    init(){
        fetchUser(uid: auth.currentUser!.uid) { userInfo in
            self.userInfo = userInfo
        }
    }
    
    
    func post(card: CardModel, forward: Bool){
        
        var card = card
        card.uid = self.uid
        
        if(!tagedPeople.isEmpty){
            
            var taggedPeopleUid = [String]()
            
            for user in tagedPeople{
                taggedPeopleUid.append(user.uid)
            }
            card.taggedPeople = taggedPeopleUid
            
            self.tagedPeople.removeAll()
            
        }
        
//        if(!forward && pickerResult.img_Data == nil && pickerResult.url == nil){
        if(!forward && result.isEmpty()){
            
            let alertInfo = AlertInfo(Title: "Error", Message: "No Photo Selected")
            if forward{
                self.forwardAlertInfo = alertInfo
            }else{
                self.newAlertInfo = alertInfo
            }
            return
        }
        
        isPosting = true
        
        
        let reference = realtime_ref.child("Posts").childByAutoId()
        guard let postId = reference.key else {return}
        
        postProgress = 10.0
        
        if forward{
            
            self.uploadCardInFirestore(id: postId, card: card, forward: false) { card in
                
                guard let card = card else {return}
                
                self.sendNotificationForTagging(card: card)
                self.addIntoNewPostLists(card: card)
                self.incrementPostTotal(uid: self.uid)
            }
            
        }else{
            
            card.id = postId
            
            card.isVideo = self.result.img_Data == nil
            
            newPostUploadImage(id: postId) { url in
                
                guard let url = url else {
                    return
                }
                
                card.image = url
                
                self.uploadCardInFirestore(id: postId, card: card, forward: false) { card in
                    
                    guard let card = card else {return}
                    
                    self.sendNotificationForTagging(card: card)
                    self.addIntoNewPostLists(card: card)
                    self.incrementPostTotal(uid: self.uid)
                }
            }
        }
    }
    
    func edit(card: CardModel, caption: String, hobby: HobbyModel, categories: [String]){
        
        isPosting = true
        
        var card = card
        card.description = caption
        card.hobby = hobby.name
        card.hobby_id = hobby.id
        card.categories = categories
        
        if(!tagedPeople.isEmpty){
            
            var taggedPeopleUid = [String]()
            
            for user in tagedPeople{
                taggedPeopleUid.append(user.uid)
            }
            card.taggedPeople = taggedPeopleUid
            
            self.tagedPeople.removeAll()
            
        }
        
        if !result.isEmpty(){
            
            newPostUploadImage(id: card.id) { url in
                
                guard let url = url else {
                    return
                }
                
                card.image = url
                
//                if let thumbnailUrl = result.thumbnailUrl{
//                    card.thumbnailUrl = thumbnailUrl
//                }
                
                card.isVideo = self.result.img_Data == nil
                
                self.uploadCardInFirestore(id: card.id, card: card, forward: false) { card in
                    
                    guard let card = card else {return}
                    
                    self.sendNotificationForTagging(card: card)
                }
            }
        }else{
            
            self.uploadCardInFirestore(id: card.id, card: card, forward: false) { card in
                
                guard let card = card else {return}
                
                self.sendNotificationForTagging(card: card)
            }
            
        }
    }
    
    func incrementPostTotal(uid: String){
        ref.collection("Users").document(uid).updateData([
            "posts": FieldValue.increment(Int64(1))
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
    
    func getJsonFromCard(card: CardModel, forward: Bool = false) -> Any?{
        
        do{
            
            let data = try encoder.encode(card)
            
            return try JSONSerialization.jsonObject(with: data)
            
        }catch{
            
            print("an error occurred", error)
            
            self.newPostAlert(forward: forward, info: AlertInfo(Title: "Failed", Message: "Error: corrupted card data, please report bugs"))
            self.isPosting = false
            
            return nil
        }
    }
    
    func newPostUploadImage(id: String, forward: Bool = false, completion: @escaping (String?) -> ()){
        
        if let img_Data = result.img_Data{
            
            let uploadTask = UploadImage(id: id, imageData: img_Data, path: "post_Pics") { result in
                if let error = result.error{
                    self.isPosting = false
                    self.newPostAlert(forward: forward, info: AlertInfo(Title: "Failed", Message: error))
                    DispatchQueue.main.async { completion(nil) }
                    return
                }
                
                guard let url = result.url else{
                    self.isPosting = false
                    self.newPostAlert(forward: forward, info: AlertInfo(Title: "Failed", Message: "Error: Empty URL"))
                    DispatchQueue.main.async { completion(nil) }
                    return
                }
                
                self.result.img_Data = nil
                DispatchQueue.main.async { completion(url) }
            }
            
            if let uploadTask = uploadTask{
                
                uploadTask.observe(.progress) { snapshot in
                  // Upload reported progress
                    
                    DispatchQueue.main.async {
                        self.postProgress = 10 + 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount) * 0.7
                    }
                }
            }
            
        }else if let url = result.url{
            
            let videoUploadTask = UploadVideo(id: id, url: url, path: "post_Videos") { result in
                
                if let error = result.error{
                    self.isPosting = false
                    self.newPostAlert(forward: forward, info: AlertInfo(Title: "Failed", Message: error))
                    DispatchQueue.main.async { completion(nil) }
                    return
                }
                
                guard let url = result.url else{
                    self.isPosting = false
                    self.newPostAlert(forward: forward, info: AlertInfo(Title: "Failed", Message: "Error: Empty URL"))
                    DispatchQueue.main.async { completion(nil) }
                    return
                }
                
                self.result.url = nil
                
                if let thumbnail = self.result.thumbnail{
                    
                    let data = thumbnail.jpegData(compressionQuality: 0.9)
                    
                    let thumbnailUploadTask = UploadImage(id: id, imageData: data!, path: "post_Videos/thumbnails") { result in
                        
                        if let error = result.error{
                            self.newPostAlert(forward: forward, info: AlertInfo(Title: "Failed", Message: error))
                            DispatchQueue.main.async { completion(nil) }
                            return
                        }
                        
                        guard let thumbnailUrl = result.url else{
                            self.newPostAlert(forward: forward, info: AlertInfo(Title: "Failed", Message: "Error: Empty URL"))
                            DispatchQueue.main.async { completion(nil) }
                            return
                        }
                        
                        self.result.thumbnail = nil
                        
                        DispatchQueue.main.async { completion(thumbnailUrl) }
                        
                    }
                    
                    if let thumbnailUploadTask = thumbnailUploadTask{
                        
                        thumbnailUploadTask.observe(.progress) { snapshot in
                          // Upload reported progress
                            DispatchQueue.main.async {
                                self.postProgress = 60 + 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount) * 0.2
                            }
                        }
                    }
                    
                }else{
                    self.newPostAlert(forward: forward, info: AlertInfo(Title: "Failed", Message: "No thumbnail found"))
                    DispatchQueue.main.async { completion(nil) }
                }
            }
            
            if let videoUploadTask = videoUploadTask{
                
                videoUploadTask.observe(.progress) { snapshot in
                  // Upload reported progress
                    DispatchQueue.main.async {
                        self.postProgress = 10 + 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount) * 0.5
                    }
                }
            }
            
            
        }
        
        
    }
    
    func uploadCardInFirestore(id: String?, card: CardModel, forward: Bool = false, completion: @escaping (CardModel?) -> ()){
        
        var reference : DatabaseReference = DatabaseReference()
        
        if let id = id{
            reference = realtime_ref.child("Posts").child(id)
        }else{
            reference = realtime_ref.child("Posts").childByAutoId()
        }
        
        let json = getJsonFromCard(card: card)
        
        reference.setValue(json){ (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                self.isPosting = false
                print("Data could not be saved: \(error).")
                self.newPostAlert(forward: forward, info: AlertInfo(Title: "Failed", Message: error.localizedDescription))
                DispatchQueue.main.async { completion(nil) }
            } else {
                print("Data saved successfully!")
                self.newPostAlert(forward: forward, info: AlertInfo(Title: "Success", Message: "Post Successfully"))
                self.isPosting = false
                DispatchQueue.main.async { completion(card) }
            }
            
        }
        
    }
    
    func postInFirebase(card: CardModel, forward: Bool, reference: DatabaseReference){
        
        postProgress = 90.0
        var card = card
        
        do{
            
//            let reference = realtime_ref.child("Posts").childByAutoId()
            
            guard let postId = reference.key else {return}
                  
            card.id = postId
            
            let data = try self.encoder.encode(card)
            
            let json = try JSONSerialization.jsonObject(with: data)
                  
            reference.setValue(json){ (error:Error?, ref:DatabaseReference) in
                
                var alertInfo = AlertInfo(Title: "", Message: "")
                
                DispatchQueue.main.async {
                    self.postProgress = 100.0
                }
                
                if let error = error {
                    self.isPosting = false
                    print("Data could not be saved: \(error).")
                    self.newPostAlert(forward: forward, info: AlertInfo(Title: "Failed", Message: error.localizedDescription))
                } else {
                    print("Data saved successfully!")
                    self.newPostAlert(forward: forward, info: AlertInfo(Title: "Success", Message: "Post Successfully"))
                    self.isPosting = false
                    self.sendNotificationForTagging(card: card)
                    self.addIntoNewPostLists(card: card)
                    self.incrementPostTotal(uid: self.uid)
                }
                
            }
            
        }catch{
            print("an error occurred", error)
            self.isPosting = false
            let alertInfo = AlertInfo(Title: "Success", Message: error.localizedDescription)
            if forward{
                self.forwardAlertInfo = alertInfo
            }else{
                self.newAlertInfo = alertInfo
            }
        }
    }
    
    func newPostAlert(forward: Bool, info: AlertInfo){
        if forward{
            self.forwardAlertInfo = info
        }else{
            self.newAlertInfo = info
        }
    }
    
    func sendNotificationForTagging(card: CardModel){
        
        guard let taggedPeople = card.taggedPeople else {return}
        
        for toUid in taggedPeople{
//            uploadNotification(toUid: toUid, notif: NotificationModel(id: "", fromUid: uid, fromUsername: nil, fromImageUrl: nil,type: Constants.NOTIFICATION_Tagged, postId: card.id, hobbyName: nil, commentId: nil))
            guard let userInfo = userInfo else {
                return
            }
            
            uploadNotification(toUid: toUid, notif: NotificationModel(id: "", toUid: toUid, from_uid: uid, from_username: userInfo.username, from_url: userInfo.imageurl, type: Constants.NOTIFICATION_Tagged, postId: card.id, hobbyName: nil, commentId: nil))
        }
    }
    
    func addIntoNewPostLists(card: CardModel){
        
        let date = Date().timeIntervalSince1970
        
        realtime_ref.child("HobbyPostLists").child(card.hobby_id).child(card.id).setValue(date)
        
        fetchHobby(uid: card.uid, hid: card.hobby_id, refresh: true) { hobby in
            
            guard let hobby = hobby else {
                print("hobby not found from db")
                return
            }
            
            guard let followers = hobby.followers else {return}
            
            for followerId in followers{
                realtime_ref.child("PostLists/\(followerId)/oldPosts/\(card.id)").setValue(date)
                realtime_ref.child("PostLists/\(followerId)/newPosts/\(card.id)").setValue("")
            }
            
            realtime_ref.child("PostLists/\(self.uid)/oldPosts/\(card.id)").setValue(date)
            realtime_ref.child("PostLists/\(self.uid)/newPosts/\(card.id)").setValue("")
        }
        
    }

    
}


func compressImage(data: Data) -> Data{
    let image: UIImage = UIImage(data: data)!
    //let resizedImage = image.aspectFittedToHeight(120)
    return image.jpegData(compressionQuality: 0.1)! // Add this line
}

extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

struct uploadURLResult{
    
    var url: String
    var thumbnailUrl : String?
    
    
}

extension uploadURLResult {
    init(url: String) {
        self.url = url
        self.thumbnailUrl = nil
    }
}

extension uploadURLResult {
    init(url: String, thumbnailUrl: String) {
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }
}
