//
//  SettingViewModel.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/1/22.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase

class TestViewModel : ObservableObject{
    
    @Published var picker = false
    @Published var showEditView : Bool = false
    @Published var result : imagePickingResult = imagePickingResult()
    
    init(){
        
    }
    
    
}
