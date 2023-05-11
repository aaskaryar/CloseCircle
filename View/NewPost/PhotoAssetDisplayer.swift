//
//  PhotoAssetDisplayer.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/29/22.
//

import SwiftUI

struct PhotoAssetDisplayer: View {
    
    @EnvironmentObject var newPostData : NewPostModel
    @State var playVideo = false
    var card : CardModel?
    let length = UIScreen.main.bounds.width - 40
    
    var body: some View {
        
        let result = newPostData.result
        
        ZStack{
            
            if let card = card{
                
                EquatableWebImage(url: card.image, size: length, shape: RoundedRectangle(cornerRadius: 15))
                
            }else if let data = result.img_Data {
                
                Image(uiImage: UIImage(data: data)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: length, height: length)
                    .cornerRadius(15)
                
                
            }else if let _ = result.url, let thumbnail = result.thumbnail{
                
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: length, height: length)
                    .cornerRadius(15)
                    .overlay(
                        VStack{
                            HStack{
                                Button {
                                    playVideo = true
                                } label: {
                                    
                                    Image(systemName: "play.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, alignment: .center)
                                        .foregroundColor(.white)
//                                        .background(
//                                            VisualEffectView(effect: UIBlurEffect(style: .dark))
//                                                .frame(width: 40, height: 40)
//                                                .clipShape(Circle())
//                                                .opacity(0.7)
//                                        )
                                    
//                                    ZStack{
//
//                                        VisualEffectView(effect: UIBlurEffect(style: .dark))
//                                            .frame(width: 40, height: 40)
//                                            .clipShape(Circle())
//                                            .opacity(0.7)
//
//
//
//                                    }
                                }
                            }
                        }
                    )
                
            }else{
                
                Image("painting")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: length, height: length)
                    .cornerRadius(15)
                    .onTapGesture{
                        newPostData.picker.toggle()
                    }
            }
            
            if result.img_Data != nil || result.url != nil{
                
                VStack(alignment: .trailing){
                    
                    HStack(alignment: .top){
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                
                                newPostData.result.img_Data = nil
                                newPostData.result.url = nil
                                newPostData.result.thumbnail = nil
                                
                                //print(newPostData.img_Data.isEmpty)
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .foregroundColor(.black)
                                .background(
                                    
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Constants.ShadeGray)
                                        .frame(width: 30, height: 30)
                                )
                        }
                        .padding(.top)
                        .padding(.trailing)
                    }
                    
                    Spacer()
                   
                }
                .frame(width: length, height: length)
            }
        }
        .fullScreenCover(isPresented: $playVideo) {
            if let url = result.url{
                VideoPlayView(url: url)
            }else{
                EmptyView()
            }
        }
    }
}

//struct PhotoAssetDisplayer_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoAssetDisplayer(card: nil, result: nil)
//    }
//}
