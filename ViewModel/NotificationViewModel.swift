//
//  NotificationViewModel.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 6/1/22.
//

import SwiftUI
import Firebase

var username = ""
var url = ""

class NotificationViewModel: ObservableObject {
    
    @Published var Notifications : [NotificationModel] = [NotificationModel]()
    //private var NotificationDic : [String] = [String]()
    private var NotificationsQueue : Queue<String> = Queue<String>()
    private var newNotificationListener : DatabaseHandle? = nil

    
    let uid = auth.currentUser!.uid
    private let decoder = JSONDecoder()
    
    init(userInfo: UserModel){
        username = userInfo.username
        url = userInfo.imageurl
        
        listenOnNewNotifications()
        
        fetchNotificationDic { dic in
            
            guard let dic = dic else {return}
            
            let NotificationDic = dic.sorted(by: { first, second in
                first.value > second.value
            }).map({$0.key})
            
            for id in NotificationDic{
                self.NotificationsQueue.enqueue(id)
            }
        }
    }
    
    deinit{
        if let newNotificationListener = newNotificationListener {
            realtime_ref.removeObserver(withHandle: newNotificationListener)
        }
    }
    
    func updateUserInfo(userInfo: UserModel){
        username = userInfo.username
        url = userInfo.imageurl
    }
    
    func listenOnNewNotifications(){
        
        newNotificationListener =  realtime_ref.child("NotificationLists").child(uid).child("newNotifs").observe(.childAdded, with: { (snapshot) -> Void in
            
            guard let id = snapshot.key as? String else {return}
                
            fetchNotification(id: id) { notification in
                self.Notifications.insert(notification, at: 0)
                print("yeah")
            }
        })
    }
    
    func fetchNotificationDic(completion: @escaping ([String: Date]?) -> ()){
        
        realtime_ref.child("NotificationLists").child(uid).child("oldNotifs").getData(completion: { error, snapShot in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            guard let snapshot = snapShot else {return}
            
            if let dictionary = snapshot.value as? [String: TimeInterval]{
                var dic = [String: Date]()
                
                for (id, time) in dictionary{
                    dic[id] = Date(timeIntervalSince1970: time)
                }
                DispatchQueue.main.async {
                    completion(dic)
                }
            }else{
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        })
    }
    
    func getOldNotifications(size: Int){
        
        var i = 0
        
        while i < size{
            
            i += 1
            
            guard let id = NotificationsQueue.dequeue() else{return}
            
            fetchNotification(id: id) { notification in
                self.Notifications.append(notification)
            }
        }
    }
    
}


func fetchNotification(id: String, completion: @escaping (NotificationModel) -> ()){
    
    let decoder = JSONDecoder()
    
    realtime_ref.child("Notifications").child(id).getData(completion: { error, snapShot in
        
        guard error == nil else {
            print(error!.localizedDescription)
            return;
        }
        guard let snapshot = snapShot else {return}
        
        if let dictionary = snapshot.value as? [String: Any]{
            
            do {
                
                let notifData = try JSONSerialization.data(withJSONObject: dictionary)
                
                var notif = try decoder.decode(NotificationModel.self, from: notifData)
                
                print(notif)
                
                DispatchQueue.main.async {
                    completion(notif)
                }
                
            } catch {
                print("an error occurred", error)
            }
        }
    })
}

func uploadNotification(toUid: String, notif: NotificationModel){
    
    let encoder = JSONEncoder()
    let date = Date().timeIntervalSince1970
    do {
        let reference = realtime_ref.child("Notifications").childByAutoId()
        
        guard let notifId = reference.key else {return}
        
        var notification = notif
        
        notification.id = notifId
        
        if notification.from_username == nil{
            notification.from_username = username
        }
        if notification.from_url == nil{
            notification.from_url = url
        }
        
        print(notifId)
        
        let data = try encoder.encode(notification)
        let json = try JSONSerialization.jsonObject(with: data)
        
        let notifData = try JSONSerialization.data(withJSONObject: json)
        var notif = try JSONDecoder().decode(NotificationModel.self, from: notifData)
        
        reference.setValue(json){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
               
            } else {
                print("Data saved Successfully")
                
                realtime_ref.child("NotificationLists/\(toUid)/oldNotifs/\(notifId)").setValue(date)
                
                realtime_ref.child("NotificationLists/\(toUid)/newNotifs/\(notifId)").setValue("")
            }
        }  
    }catch{
        print("an error occurred", error)
    }
    
}
