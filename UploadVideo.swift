//
//  UploadVideo.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 8/1/22.
//

import Foundation
import Firebase

func UploadVideo(id: String, url: URL, path: String, completion: @escaping (uploadImageResult) -> ()) -> StorageUploadTask?{
    
    let storage = storage.reference()
    
    guard let user = auth.currentUser else{
        print("no uid found")
        return nil
    }
    
    let data = NSData(contentsOf: url)
    
    guard let data = data as? Data else{
        print("Wrong Data URL")
        completion(uploadImageResult(error: "Wrong Data URL"))
        return nil
    }
    
    return storage.child(path).child(user.uid).child(id).putData(data, metadata: nil) { (_, err) in
        
        if let err = err{
            print("BADBADBAD")
            print(err)
            completion(uploadImageResult(error: err.localizedDescription))
            return
            
        }
        
        // Downloading Url And Sending Back...
        
        storage.child(path).child(user.uid).child(id).downloadURL { (url, err) in
            if let err = err{
                completion(uploadImageResult(error: err.localizedDescription))
                return
                
            }
            if let url = url{
                completion(uploadImageResult(url: "\(url)"))
            }else{
                completion(uploadImageResult(error: "Empty url, Unable to upload image"))
            }
        }
    }
}
