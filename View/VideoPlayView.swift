//
//  VideoPlayView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/31/22.
//

import SwiftUI
import AVFoundation
import AVKit

struct VideoPlayView: View {
    @Environment(\.dismiss) var dismiss
    //@StateObject var videoData : VideoViewModel
    @State var player : AVPlayer
    var url : URL
    
    init(url: URL){
        //_videoData = StateObject(wrappedValue: VideoViewModel(url: url))
        print(url)
        self.url = url
        _player = State(wrappedValue: AVPlayer(url: url))
    }
    var body: some View {
        
        ZStack{
            
//            if videoData.ratio != 0{
//                EquatableVideoPlayer(player: player, url: url, ratio: videoData.ratio)
//                    .equatable()
//            }else{
//                ProgressView()
//            }
            EquatableVideoPlayer(player: player, url: url, ratio: 9/16, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 200)
                .equatable()
            
            VStack{
                
                HStack{
                    
                    Spacer()
                    
                    Button {
                        dismiss()
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
        }
        .background(.black)
        .onAppear{
            player.play()
        }
    }
}

struct VideoPlayView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayView(url: URL(string: "file:///Users/xueyaozhou/Library/Developer/CoreSimulator/Devices/82B88E14-59C9-4BD4-B9D3-16C5B2864079/data/Containers/Shared/AppGroup/1284F2AA-0306-4F44-B2BC-7B49BC8E6D1B/File%20Provider%20Storage/photospicker/version=1&uuid=C9D4B867-4651-4E9B-BD7A-087CDD48F179&mode=compatible.mov")!)
    }
}
