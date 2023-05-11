//
//  ImagePickerNavigation.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/29/22.
//

import SwiftUI

struct ImagePickerNavigation<Content: View>: View {
    
    @Binding var isActive : Bool
    @Binding var picker: Bool
    @Binding var result : imagePickingResult
    @State var progress : Progress?
    @State var showProgress : Bool = false
    var content: Content
    
    var body: some View{
        
        NavigationView{
            
            ZStack{
                
                ImageVideoPicker(picker: $picker, progress: $progress, result: $result)
                    .opacity(showProgress ? 0.5 : 1)
                    .disabled(showProgress)
                    //.navigationBarHidden(true)
                NavigationLink(destination: content, isActive: $isActive) { EmptyView() }
                
                if let progress = progress {
                    ProgressView(progress)
                        .progressViewStyle(CircularProgressViewStyle(tint: Constants.ShadeGreen))
                        .onAppear{
                            showProgress = true
                        }
                }
                
            }
           // .navigationTitle("yes")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                DispatchQueue.main.async {
                    progress = nil
                    showProgress = false
                }
            }
            
        }
    }
}
