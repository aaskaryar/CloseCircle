//
//  PhotoPickerModifier.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/30/22.
//

import SwiftUI

struct PhotoPickerModifier: ViewModifier {
    
    @EnvironmentObject var newPostData : NewPostModel
    @Binding var result: imagePickingResult
    @Binding var showEditView : Bool
    @Binding var picker : Bool
    
    func body(content: Content) -> some View {
        
        content
            .onChange(of: result.count) { _ in
                //print("Detected")
                showEditView = true
            }
            .fullScreenCover(isPresented: $picker) {
                
                ImagePickerNavigation(isActive: $showEditView, picker: $picker, result: $result, content: AssetEditView(result: result).navigationBarHidden(true).navigationBarBackButtonHidden(true).environmentObject(newPostData))
                    .onDisappear {
                        showEditView = false
                    }
            }
        
    }
}
