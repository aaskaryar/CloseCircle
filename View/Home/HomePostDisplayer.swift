//
//  HomePostDisplayer.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 8/1/22.
//

import SwiftUI

struct HomePostDisplayer: View {
    
    @EnvironmentObject var videoCacheData : VideoCacheModel
    var uid: String
    var pid: String
    @State var videoUrl : URL?

    var body: some View {
        ZStack{
            if videoCacheData.isLoading{
                VStack{
                    ProgressView("Downloading…", value: videoCacheData.percentComplete, total: 100)
                        .frame(width: UIScreen.main.bounds.width - 40)
                        .progressViewStyle(CircularProgressViewStyle(tint: Constants.ShadeGreen))
                        //.progressViewStyle(CircularProgressViewStyle(tint: Constants.ShadeGreen))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.ignoresSafeArea())
            }else if let videoUrl = videoUrl {
                VideoPlayView(url: videoUrl)
            }else{
                ErrorDismissView(error: videoCacheData.errorMessage)
            }
        }
        .onAppear{
            videoCacheData.getVideo(uid: uid, pid: pid) { url in
                if let url = url{
                    self.videoUrl = url
                }
            }
        }
        //.modifier(LoadingModifier(isLoading: $videoCacheData.isLoading))
    }
}

//struct HomePostDisplayer_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePostDisplayer()
//    }
//}
