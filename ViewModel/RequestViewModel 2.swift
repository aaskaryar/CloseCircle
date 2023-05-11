//
//  SearchViewModel.swift
//  ShadeInc
//
//  Created by Macbook on 4/20/22.
//

import SwiftUI
import Firebase

class RequestViewModel: ObservableObject {
    
    var uid : String
    //var userInfo : UserModel
    var noRequests = false
    var requestsCount = 0
    @Published var requests = [Request]()
    @Published var myPendingRequests = [Request]()
    var realtime_ref = Database.database().reference()
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
    
    func followHobby(hobby: HobbyModel, userInfo: UserModel){
        if(hobby.privacy == Constants.Private){
            print("Sending Requests")
            sendRequest(hobby: hobby , userInfo: userInfo)
        }else if (hobby.privacy == Constants.Public){
            print("no need Requests")
            followHobbyInFirestore(followerUid: self.uid, followingUid: hobby.uid, hobbyId: hobby.id)
        }
    }
    
    func sendRequest(hobby: HobbyModel, userInfo: UserModel){
        print(userInfo.uid)
        print(hobby.uid)
        isRequesting = true
        
        ref.collection("Requests").document().setData([
            
            "to_uid" : hobby.uid,
            "from_uid" : userInfo.uid,
            "from_username" : userInfo.username,
            "from_url" : userInfo.imageurl,
            "time" : Date(),
            "hobby" : hobby.name,
            "hobby_id" : hobby.id,
            "public" : hobby.privacy == "Public" ? true : false,
            "status" : "Pending",

        ]){ (err) in
            
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
        
        followHobbyInFirestore(followerUid: request.from_uid, followingUid: request.to_uid, hobbyId: request.hobby_id)
        
        ref.collection("Requests").document(request.id).updateData([
            "status" : Constants.accept
        ])
        
    }
    
    
    func refuseRequest(request: Request){
        
        
        requestsCount -= 1
        let index = self.requests.firstIndex { (request1) -> Bool in
            return request1.id == request.id
        } ?? -1
        
        if index != -1{
            self.requests[index].status = Constants.refused
        }
        
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
                // print(doc.document.documentID)
                // Checking If Doc Added...
                if doc.type == .added{

                    let data = doc.document.data()

                    var to_uid = ""
                    var from_uid = ""
                    var from_username = ""
                    var from_url = ""
                    var time = Date()
                    var hobby = ""
                    var hobby_id = ""
                    var isPublic = false
                    var status = ""

                    if(data["to_uid"] != nil){
                        to_uid = data["to_uid"] as! String
                    }

                    if(data["from_uid"] != nil){
                        from_uid = data["from_uid"] as! String
                    }

                    if(data["from_username"] != nil){
                        from_username = data["from_username"] as! String
                    }

                    if(data["from_url"] != nil){
                        from_url = data["from_url"] as! String
                    }

                    if(data["hobby"] != nil){
                        hobby = data["hobby"] as! String
                    }

                    if(data["hobby_id"] != nil){
                        hobby_id = data["hobby_id"] as! String
                    }

                    if(data["time"] != nil){
                        let timestamp = data["time"] as! Timestamp
                        time = timestamp.dateValue()
                    }
                    
                    if(data["public"] != nil){
                        isPublic = data["public"] as! Bool
                    }
                    
                    if(data["status"] != nil){
                        status = data["status"] as! String
                    }

                    let request = Request(id: doc.document.documentID, to_uid: to_uid, from_uid: from_uid, from_username: from_username, from_url: from_url, hobby: hobby, hobby_id: hobby_id, time: time, status: status, isPublic: isPublic)

                    self.requests.append(request)
                    print("request: ", request.hobby)
                    
                    if(status == "Pending"){
                        self.requestsCount += 1
                    }
                }

//                if doc.type == .removed{
//
//                    let id = doc.document.documentID as! String
//
//                    print("removed")
//
//                    self.requests.removeAll { (request) -> Bool in
//                        return request.id == id
//                    }
//                }
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
                // print(doc.document.documentID)
                // Checking If Doc Added...
                if doc.type == .modified{
                    
                    let data = doc.document.data()
                    
                    var to_uid = ""
                    var from_uid = ""
                    var from_username = ""
                    var from_url = ""
                    var time = Date()
                    var hobby = ""
                    var hobby_id = ""
                    var isPublic = false
                    var status = ""

                    if(data["to_uid"] != nil){
                        to_uid = data["to_uid"] as! String
                    }

                    if(data["from_uid"] != nil){
                        from_uid = data["from_uid"] as! String
                    }

                    if(data["from_username"] != nil){
                        from_username = data["from_username"] as! String
                    }

                    if(data["from_url"] != nil){
                        from_url = data["from_url"] as! String
                    }

                    if(data["hobby"] != nil){
                        hobby = data["hobby"] as! String
                    }

                    if(data["hobby_id"] != nil){
                        hobby_id = data["hobby_id"] as! String
                    }

                    if(data["time"] != nil){
                        let timestamp = data["time"] as! Timestamp
                        time = timestamp.dateValue()
                    }
                    
                    if(data["public"] != nil){
                        isPublic = data["public"] as! Bool
                    }
                    
                    if(data["status"] != nil){
                        status = data["status"] as! String
                    }

                    let request = Request(id: doc.document.documentID, to_uid: to_uid, from_uid: from_uid, from_username: from_username, from_url: from_url, hobby: hobby, hobby_id: hobby_id, time: time, status: status, isPublic: isPublic)

                    self.myPendingRequests.append(request)
                    
                    if(status == Constants.accept){
//                        ref.collection("Users").document(self.uid).updateData([
//                            "followingUsers.\(to_uid)" : FieldValue.arrayUnion([hobby_id])
//                        ])
                        self.deleteRequest(id: doc.document.documentID)
                    }
                    
                    if(status == Constants.refused){
                        self.deleteRequest(id: doc.document.documentID)
                    }
                    
                }
                
//                if doc.type == .modified{
//
//                    let id = doc.document.documentID
//                    let status = doc.document.data()["status"] as! String
//
//                    let index = self.myPendingRequests.firstIndex { (request) -> Bool in
//                        return request.id == id
//                    } ?? -1
//
//                    // safe Check...
//                    // since we have safe check so no worry
//
//                    if index != -1{
//
//                        self.myPendingRequests[index].status = status
//                    }
//
//                }
            }
        }
        
    }
    
    func addObserverOnNotification(id: String){
        
        realtime_ref.child("Users").child(uid).child("Notifications").observe(.childAdded, with: { (snapshot) -> Void in
            
            //let value = snapshot.value as? NSDictionary
        })
        
    }
}

func followHobbyInFirestore(followerUid: String, followingUid: String, hobbyId: String){
    ref.collection("Users").document(followingUid).updateData([
        "followerUsers" : FieldValue.arrayUnion([followerUid])
    ])
    
    ref.collection("Users").document(followerUid).updateData([
        "followingUsers.\(followingUid)" : FieldValue.arrayUnion([hobbyId]),
    ])
    
    ref.collection("Users").document(followingUid).collection("Hobbies").document(hobbyId).updateData([
        "followers" : FieldValue.arrayUnion([followerUid])
    ])
}
