//
//  EquatableWebImage.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/25/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct EquatableWebImage<Content: Shape>: View, Equatable {
    
    var url : String
    var size : CGFloat
    var shape : Content
    
    var body: some View {
        
        ZStack{
            
            if let url = URL(string: url){
                
                let scale = UIScreen.main.scale // Will be 2.0 on 6/7/8 and 3.0 on 6+/7+/8+ or later
                let thumbnailSize = CGSize(width: size * scale, height: size * scale) // Thumbnail w
                
                
                WebImage(url: url, context: [.imageThumbnailPixelSize : thumbnailSize])
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            }else{
                
               Image("default")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
            }
        }
        .frame(width: size, height:size, alignment: .center)
        //.clipped()
        .clipShape(shape)
        .contentShape(shape)
        
    }
    
    static func == (lhs: EquatableWebImage, rhs: EquatableWebImage) -> Bool {
        return lhs.url == rhs.url
    }
}
