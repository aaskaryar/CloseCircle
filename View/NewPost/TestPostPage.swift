//
//  TestPostPage.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/30/22.
//

import SwiftUI

struct TestPostPage: View {
    @EnvironmentObject var newPostData: NewPostModel
    
    var body: some View {
        
        VStack{
            PhotoAssetDisplayer()
        }
        .modifier(PhotoPickerModifier(result: $newPostData.result, showEditView: $newPostData.showEditView, picker: $newPostData.picker))
    }
}

struct envionmentPreviewPage: View{
    @StateObject var newPostData: NewPostModel = NewPostModel()
    
    var body: some View{
        TestPostPage()
            .environmentObject(newPostData)
    }
    
}

struct TestPostPage_Previews: PreviewProvider {
    static var previews: some View {
        envionmentPreviewPage()
    }
}
