//
//  HobbyDetailPost.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/25/22.
//  No longer in Use
//

//import SwiftUI
//import SDWebImageSwiftUI
//
//struct HobbyDetailPost: View {
//
//    var border : Bool
//    var image : String
//    let length = UIScreen.main.bounds.width * 0.28
//
//    var body: some View {
//
//        ZStack{
////
//            if let url = URL(string: image){
//
//                let scale = UIScreen.main.scale // Will be 2.0 on 6/7/8 and 3.0 on 6+/7+/8+ or later
//                let thumbnailSize = CGSize(width: 200 * scale, height: 200 * scale) // Thumbnail w
//
//                WebImage(url: url, context: [.imageThumbnailPixelSize : thumbnailSize])
//                    .resizable()
//                    .scaledToFill()
//            }else{
//
//                Image("default")
//                   .resizable()
//                   .aspectRatio(contentMode: .fill)
//            }
//
//        }
//        .frame(width: length, height: length)
//        .cornerRadius(12)
//        .contentShape(RoundedRectangle(cornerRadius: 12))
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(border ? Constants.ShadeTeal : .black , lineWidth: border ? 5 : 0)
//        )
//        .padding(.top, 5)
//    }
//}
////
////struct HobbyDetailPost_Previews: PreviewProvider {
////    static var previews: some View {
////        HobbyDetailPost()
////    }
////}
