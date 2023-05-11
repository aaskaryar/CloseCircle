//
//  UploadImage.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/5/22.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct uploadImageResult{
    var url: String?
    var error : String?
}

extension uploadImageResult {
    init(error: String) {
        url = nil
        self.error = error
    }
}

extension uploadImageResult {
    init(url: String) {
        self.url = url
        error = nil
    }
}

func UploadImage(id: String, imageData: Data, path: String, completion: @escaping (uploadImageResult) -> ()) -> StorageUploadTask?{
    
    let storage = storage.reference()
    
    guard let user = auth.currentUser else{
        print("no uid found")
        return nil
    }
    
    return storage.child(path).child(user.uid).child(id).putData(imageData, metadata: nil) { (_, err) in
        
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

func UploadImageForUid(id: String, imageData: Data, path: String, uid: String, completion: @escaping (uploadImageResult) -> ()) -> StorageUploadTask?{
    
    let storage = storage.reference()
    
    guard let user = auth.currentUser else{
        print("no uid found")
        return nil
    }
    
    return storage.child(path).child(uid).child(id).putData(imageData, metadata: nil) { (_, err) in
        
        if let err = err{
            print("BADBADBAD")
            print(err)
            completion(uploadImageResult(error: err.localizedDescription))
            return
            
        }
        
        // Downloading Url And Sending Back...
        
        storage.child(path).child(uid).child(id).downloadURL { (url, err) in
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

