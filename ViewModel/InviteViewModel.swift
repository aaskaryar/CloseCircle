//
//  InviteViewModel.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 8/12/22.
//

import Foundation
import SwiftUI
import Firebase

class InviteViewModel: ObservableObject{
    
    var userInfo : UserModel
    var inviteCounts = 0
    @Published var invites = [Invite]()
    @Published var myPendingInvitess = [Invite]()
    var isInviting = false
    
    init(userInfo: UserModel){
        self.userInfo = userInfo
        getInvitesToMe(uid: userInfo.uid)
        getMyInvites()
        //self.userInfo = userInfo
//        getMyPendingRequests()
//        addRequestListener(uid: uid)
        
        //print(uid)
    }
    
    func sendInvite(hobby: HobbyModel, toUserInfo: UserModel){

        isInviting = true
        
        let invite = Invite(id: "", toUid: hobby.uid, from_uid: userInfo.uid, from_username: userInfo.username, from_url: userInfo.imageurl, hobby:  hobby.name, hobbyId: hobby.id, status: Constants.pending, to_username: toUserInfo.username, to_url: toUserInfo.imageurl)
        
        let inviteRef = ref.collection("Invites").document()
        
        invite.id = inviteRef.documentID
        
        guard let data = invite.dictionary else {return}
        
        inviteRef.setData(data){ (err) in
            
            self.isInviting = false
        }
    }
    
    func accpetInvites(invite: Invite){
        
        let index = self.invites.firstIndex { (invite1) -> Bool in
            return invite1.id == invite.id
        } ?? -1
        
        if index != -1{
            self.invites[index].status = Constants.accept
        }
        
        inviteCounts -= 1
        
        //deletePending(hobbyUid: request.to_uid, hobbyId: request.hobby_id, userId: request.from_uid)
        
        followHobbyInFirestore(followerUid: invite.to_uid, followingUid: invite.from_uid, hobbyId: invite.hobby_id, hobbyName: invite.hobby)
        
        ref.collection("Invites").document(invite.id).updateData([
            "status" : Constants.accept
        ])
        
        fetchHobbyPostList(hobbyId: invite.hobby_id) { postList in
            guard let postList = postList else {
                print("hobbyPostList not found from db")
                return
            }
            
            for (postId, time) in postList{
                
                realtime_ref.child("PostLists").child(invite.to_uid).child("oldPosts").child(postId).setValue(time.timeIntervalSince1970)
            }
        }
    }
    
    
    func refuseInvite(invite: Invite){
        
        
        inviteCounts -= 1
        let index = self.invites.firstIndex { (invite1) -> Bool in
            return invite1.id == invite.id
        } ?? -1
        
        if index != -1{
            self.invites[index].status = Constants.refused
        }
        
        //deletePending(hobbyUid: request.to_uid, hobbyId: request.hobby_id, userId: request.from_uid)
        
        ref.collection("Invites").document(invite.id).updateData([
            "status" : Constants.refused
        ])
        
    }
    
//    func deleteRequest(id: String){
//        ref.collection("Requests").document(id).delete() { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//            }
//        }
//    }
    
    func getInvitesToMe(uid: String){

        ref.collection("Invites").whereField("to_uid", isEqualTo: uid).addSnapshotListener{ (snap, err) in

            guard let docs = snap else{
                return
            }

            if docs.documentChanges.isEmpty{
                return
            }

            docs.documentChanges.forEach { (doc) in
                
                let data = doc.document.data()
                guard let invite = getInviteFromDic(data: data) else {return}
                
                if doc.type == .added{
                    
                    self.invites.append(invite)
                    
                    if(invite.status == Constants.pending){
                        self.inviteCounts += 1
                    }
                }else if doc.type == .modified{
                    self.invites = self.invites.filter({$0.id != invite.id})
                    self.invites.insert(invite, at: 0)
                }else if doc.type == .removed{
                    self.invites = self.invites.filter({$0.id != invite.id})
                }
            }
            
        }
    }
    
    func getMyInvites(){
        
        ref.collection("Invites").whereField("from_uid", isEqualTo: self.userInfo.uid).addSnapshotListener{ (snap, err) in
            
            guard let docs = snap else{
                return
            }

            if docs.documentChanges.isEmpty{
                return
            }

            docs.documentChanges.forEach { (doc) in
                
                let data = doc.document.data()
                guard let invite = getInviteFromDic(data: data) else {return}

                if doc.type == .added{
                    
                   
                    self.myPendingInvitess.append(invite)
                    
//                    if(request.status == Constants.accept){
//                        self.deleteRequest(id: doc.document.documentID)
//                    }
//
//                    if(request.status == Constants.refused){
//                        self.deleteRequest(id: doc.document.documentID)
//                    }
                    
                }else if doc.type == .modified{
                    self.myPendingInvitess = self.myPendingInvitess.filter({$0.id != invite.id})
                    self.myPendingInvitess.insert(invite, at: 0)
                }else if doc.type == .removed{
                    self.myPendingInvitess = self.myPendingInvitess.filter({$0.id != invite.id})
                }
            }
        }
        
    }
}
//
func getInviteFromDic(data: [String: Any]) -> Invite?{
    
    var data = data
    
    if let timestamp = data["time"] as? Timestamp{
        data["time"] = timestamp.dateValue().timeIntervalSince1970
    }
    
    
    do{
        let inviteData = try JSONSerialization.data(withJSONObject: data)
        return try decoder.decode(Invite.self, from: inviteData)
        
    }catch{
        print(error)
        return nil
    }
}
