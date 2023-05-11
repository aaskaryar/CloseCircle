//
//  AssetEditView.swift
//
//  Created by Aria Askaryar on 7/29/22.
//

import SwiftUI
import Mantis

struct AssetEditView: View {
    
    @EnvironmentObject var newPostData : NewPostModel
    @Environment(\.dismiss) var dismiss
    
    var result : imagePickingResult
    
    var body: some View {
        
        ZStack{
            if let url = result.url{
                
                VideoTrimmingView(url: url)
                
               
                    //.navigationTitle("yes")
//                    .navigationBarHidden(true)
//                    .navigationBarBackButtonHidden(true)
                    //.edgesIgnoringSafeArea([.top, .bottom])
                
            }else if let _ = result.img_Data{
                
                let presetFixedRatioType : Mantis.PresetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 1)
                let cropShapeType: Mantis.CropShapeType = .rect
                
                ImageCropper(result: $newPostData.result,
                             picker: $newPostData.picker,
                             cropShapeType: cropShapeType,
                             presetFixedRatioType: presetFixedRatioType)
                    .ignoresSafeArea()
                
                
            }else{
                EmptyView()
            }
        }
        //.navigationTitle("yes")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
        
    }
}

struct AssetEditView_Previews: PreviewProvider {
    static var previews: some View {
        testEnvionmentView()
    }
}

struct testEnvionmentView: View{
    
    @StateObject var test : NewPostModel = NewPostModel()
   // @State var isNavigationBarHidden : Bool = true
    
    var body: some View{
        
        AssetEditView(result: imagePickingResult(url: URL(string: "file:///Users/xueyaozhou/Library/Developer/CoreSimulator/Devices/82B88E14-59C9-4BD4-B9D3-16C5B2864079/data/Containers/Shared/AppGroup/1284F2AA-0306-4F44-B2BC-7B49BC8E6D1B/File%20Provider%20Storage/photospicker/version=1&uuid=C9D4B867-4651-4E9B-BD7A-087CDD48F179&mode=compatible.mov")!))
            .environmentObject(test)
    }
    
}
