//
//  FollowingViewModel.swift
//  ShadeInc
//
//  Created by Randi Gjoni on 5/10/22.
//

import SwiftUI
import SwiftUI
import Firebase

class FollowingViewModel: ObservableObject {
    let ref = Firestore.firestore()
    init()
    {
        print("Testing has began")
        let docRef = ref.collection("Users").document("vAgQFyhiBTQuPR5AJaprpUBti6B3")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let user_count = document.data()?["followinghobbies"]
                print(user_count)
               // self.userNumber = user_count as! Int
                
            } else {
                
            }
        }
        print("Testing has ended")
    }
}
