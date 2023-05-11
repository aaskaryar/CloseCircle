//
//  SearchViewModel.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/20/22.
//

import SwiftUI
import Firebase

class RequestViewModel: ObservableObject {
    
    var uid : String
    var noRequests = false
    var requestsCount = 0
    @Published var requests = [Request]()
    @Published var myPendingRequests = [Request]()
    var isRequesting = false
    
    init(uid: String){
        self.uid = uid
        getRequestsToMe(uid: uid)
        getMyRequests()
        //self.userInfo = userInfo
//        getMyPendingRequests()
//        addRequestListener(uid: uid)
        
        //print(uid)
    }
    
    func followHobby(hobby: HobbyModel, userInfo: UserModel) -> Bool{
        if(hobby.privacy == Constants.Private){
            print("Sending Requests")
            addPending(hobby: hobby, userId: userInfo.uid)
            fetchUser(uid: hobby.uid) { toUserInfo in
                if let toUserInfo = toUserInfo {
                    self.sendRequest(hobby: hobby , userInfo: userInfo, toUserInfo: toUserInfo)
                }
            }
            
            return true
        }else{
            print("no need Requests")
            followHobbyInFirestore(followerUid: self.uid, followingUid: hobby.uid, hobbyId: hobby.id, hobbyName: hobby.name)
            return false
        }
    }
    
    func addPending(hobby: HobbyModel, userId: String){
        ref.collection("Users").document(hobby.uid).collection("Hobbies").document(hobby.id).updateData([
            "pendingFollowers" : FieldValue.arrayUnion([userId])
        ])
    }
    
    func deletePending(hobbyUid: String, hobbyId:String, userId: String){
        ref.collection("Users").document(hobbyUid).collection("Hobbies").document(hobbyId).updateData([
            "pendingFollowers" : FieldValue.arrayRemove([userId])
        ])
    }
    
    func sendRequest(hobby: HobbyModel, userInfo: UserModel, toUserInfo: UserModel){
        print(userInfo.uid)
        print(hobby.uid)
        isRequesting = true
        
        let request = Request(id: "", toUid: hobby.uid, from_uid: userInfo.uid, from_username: userInfo.username, from_url: userInfo.imageurl, hobby:  hobby.name, hobbyId: hobby.id, status: Constants.pending, to_username: toUserInfo.username, to_url: toUserInfo.imageurl)
        
        let requestRef = ref.collection("Requests").document()
        
        request.id = requestRef.documentID
        
        guard let data = request.dictionary else {return}
        
        requestRef.setData(data){ (err) in
            
            if err != nil{
                self.isRequesting = false
                return
            }
            
            self.isRequesting = false
        }
    }
    
    func accpetRequest(request: Request){
        
        let index = self.requests.firstIndex { (request1) -> Bool in
            return request1.id == request.id
        } ?? -1
        
        if index != -1{
            self.requests[index].status = Constants.accept
        }
        
        requestsCount -= 1
        
        deletePending(hobbyUid: request.to_uid, hobbyId: request.hobby_id, userId: request.from_uid)
        
        followHobbyInFirestore(followerUid: request.from_uid, followingUid: request.to_uid, hobbyId: request.hobby_id, hobbyName: request.hobby)
        
        ref.collection("Requests").document(request.id).updateData([
            "status" : Constants.accept
        ])
        
        fetchHobbyPostList(hobbyId: request.hobby_id) { postList in
            guard let postList = postList else {
                print("hobbyPostList not found from db")
                return
            }
            
            for (postId, time) in postList{
                
                realtime_ref.child("PostLists").child(request.from_uid).child("oldPosts").child(postId).setValue(time.timeIntervalSince1970)
            }
        }
    }
    
    
    func refuseRequest(request: Request){
        
        
        requestsCount -= 1
        let index = self.requests.firstIndex { (request1) -> Bool in
            return request1.id == request.id
        } ?? -1
        
        if index != -1{
            self.requests[index].status = Constants.refused
        }
        
        deletePending(hobbyUid: request.to_uid, hobbyId: request.hobby_id, userId: request.from_uid)
        
        ref.collection("Requests").document(request.id).updateData([
            "status" : Constants.refused
        ])
        
    }
    
    func deleteRequest(id: String){
        ref.collection("Requests").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func getRequestsToMe(uid: String){

        ref.collection("Requests").whereField("to_uid", isEqualTo: uid).addSnapshotListener{ (snap, err) in

            guard let docs = snap else{
                self.noRequests = true
                return
            }

            if docs.documentChanges.isEmpty{
                self.noRequests = true
                return
            }

            self.noRequests = false

            docs.documentChanges.forEach { (doc) in
                
                let data = doc.document.data()
                guard let request = getRequestFromDic(data: data) else {return}
                
                if doc.type == .added{
                    
                    self.requests.append(request)
                    
                    if(request.status == Constants.pending){
                        self.requestsCount += 1
                    }
                }else if doc.type == .modified{
                    self.requests = self.requests.filter({$0.id != request.id})
                    self.requests.insert(request, at: 0)
                }else if doc.type == .removed{
                    self.requests = self.requests.filter({$0.id != request.id})
                }
            }
            
        }
    }
    
    func getMyRequests(){
        
        ref.collection("Requests").whereField("from_uid", isEqualTo: self.uid).addSnapshotListener{ (snap, err) in
            
            guard let docs = snap else{
                self.noRequests = true
                return
            }

            if docs.documentChanges.isEmpty{
                self.noRequests = true
                return
            }

            self.noRequests = false

            docs.documentChanges.forEach { (doc) in
                
                let data = doc.document.data()
                guard let request = getRequestFromDic(data: data) else {return}

                if doc.type == .added{
                    
                   
                    self.myPendingRequests.append(request)
                    
//                    if(request.status == Constants.accept){
//                        self.deleteRequest(id: doc.document.documentID)
//                    }
//
//                    if(request.status == Constants.refused){
//                        self.deleteRequest(id: doc.document.documentID)
//                    }
                    
                }else if doc.type == .modified{
                    self.myPendingRequests = self.myPendingRequests.filter({$0.id != request.id})
                    self.myPendingRequests.insert(request, at: 0)
                }else if doc.type == .removed{
                    self.myPendingRequests = self.myPendingRequests.filter({$0.id != request.id})
                }
            }
        }
        
    }
}
//
func getRequestFromDic(data: [String: Any]) -> Request?{
    
    var data = data
    
    if let timestamp = data["time"] as? Timestamp{
        data["time"] = timestamp.dateValue().timeIntervalSince1970
    }
    
    
    do{
        let requestData = try JSONSerialization.data(withJSONObject: data)
        return try decoder.decode(Request.self, from: requestData)
        
    }catch{
        print(error)
        return nil
    }
}

func followHobbyInFirestore(followerUid: String, followingUid: String, hobbyId: String, hobbyName: String){
    ref.collection("Users").document(followingUid).updateData([
        "followerUsers.\(followerUid)" : FieldValue.arrayUnion([hobbyId])
    ])
    
    ref.collection("Users").document(followerUid).updateData([
        "followingUsers.\(followingUid)" : FieldValue.arrayUnion([hobbyId]),
    ])
    
    ref.collection("Users").document(followingUid).collection("Hobbies").document(hobbyId).updateData([
        "followers" : FieldValue.arrayUnion([followerUid])
    ])
    
    fetchUser(uid: followerUid) { user in
        guard let user = user else {return}
        uploadNotification(toUid: followingUid, notif: NotificationModel(id: "", toUid: followingUid, from_uid: followerUid, from_username: user.username, from_url: user.imageurl, type: Constants.NOTIFICATION_FOLLOW, postId: nil, hobbyName: hobbyName, commentId: nil))
    }
    
}
