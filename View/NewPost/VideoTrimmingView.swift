//
//  VideoTrimmingView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/28/22.
//

import SwiftUI
import AVFoundation
import AVKit

struct VideoTrimmingView: View{
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var newPostData : NewPostModel
    @StateObject var videoData : VideoViewModel
    @State var startPos: CGFloat = .zero
    @State var endPos: CGFloat = .zero
    @State var player : AVPlayer
    @State var positionDurationRatio : Double = 0
    var maxDuration : Double
    var minDuration : Double
    var url : URL
    
    init(url: URL){
        _videoData = StateObject(wrappedValue: VideoViewModel(url: url))
        print("here", url)
        self.url = url
        maxDuration = 30.0
        minDuration = 0.1
        _player = State(wrappedValue: AVPlayer(url: url))
    }
    
    var body: some View{
        
        VStack(alignment: .center){
            
            
            
            //var positionDurationRatio = videoData.positionDurationRatio
            EquatableVideoPlayer(player: player, url: url, ratio: 9/16, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 300)
                .equatable()
            
            Text(String(videoData.ratio))
//            if videoData.ratio != 0{
//                EquatableVideoPlayer(player: player, url: url, ratio: 9/16, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 300)
//                    .equatable()
//
//                Text(String(videoData.ratio))
//            }
            
            GeometryReader{ reader in
                
                //scale : Double // scale between length of thumbnails and video length
                
                VStack(alignment: .center){
                    
                    let mid = reader.frame(in: .local).midX
                    let max = reader.frame(in: .local).maxX
                    let minDurationScaled = minDuration * positionDurationRatio
                    let maxDurationScaled = maxDuration * positionDurationRatio
                    //Text(String(Int(predict.x)))
                    //Text(String(Int(reader.frame(in: .local).minX)))
                    
                    HStack(spacing: 0){
                        
                        ForEach(videoData.thumbnails, id:\.self){ image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: videoData.thumbnailHeight * 9 / 16, height: videoData.thumbnailHeight)
                                .clipped()
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - 80, height: videoData.thumbnailHeight, alignment: .center)
                    .overlay(
                        DragBar(backColor: .white, frontColor: .gray, height: 60, width: 10)
                            .offset(x: startPos - mid, y: 0)
                            .gesture(
                                DragGesture()
                                    .onChanged({ gesture in
                                        
                                        var position : CGFloat = gesture.translation.width + gesture.startLocation.x + mid
                                        
                                        if position < 0{
                                            position = 0
                                        }else if position > (max -  minDurationScaled){
                                            position = (max -  minDurationScaled)
                                        }
                                        
                                        startPos = position
                                        
                                        if startPos + minDurationScaled > endPos{
                                            endPos = startPos + minDurationScaled
                                        }
                                        
                                        if startPos + maxDurationScaled < endPos{
                                            endPos = startPos + maxDurationScaled
                                        }
                                        
                                        player.pause()
                                        
                                        player.seek(to: CMTime(seconds: startPos / positionDurationRatio, preferredTimescale: 600), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                                        
                                       
                                    })
                                    .onEnded({ _ in
                                        
                                        let timeValue = NSValue(time: CMTime(seconds: endPos / positionDurationRatio, preferredTimescale: 600))
                                        player.addBoundaryTimeObserver(forTimes: [timeValue], queue: nil) {
                                            //print("pause")
                                            var time = CMTime()
                                            timeValue.getValue(&time)
                                            //print(String((endPos / positionDurationRatio)))
                                            
                                            if abs(CMTimeGetSeconds(time) - (endPos / positionDurationRatio)) < 0.01{
                                                player.pause()
                                            }else{
                                                //print("pass at: \(String(CMTimeGetSeconds(time)))")
                                            }
                                        }
                                        
                                        player.play()
                                    })
                            )
                    )
                    .overlay(
                        
                        DragBar(backColor: .white, frontColor: .gray, height: 60, width: 10)
                            .offset(x: endPos - mid, y: 0)
                            .gesture(
                                DragGesture()
                                    .onChanged({ gesture in
                                        
                                        var position : CGFloat = gesture.translation.width + gesture.startLocation.x + mid
                                        
                                        if position < minDurationScaled{
                                            position = minDurationScaled
                                        }else if position > max{
                                            position = max
                                        }
                                        
                                        endPos = position
                                        
                                        if endPos - minDurationScaled < startPos{
                                            startPos = endPos - minDurationScaled
                                        }
                                        
                                        if endPos - maxDurationScaled > startPos{
                                            startPos = endPos - maxDurationScaled
                                        }
                                       
                                        player.pause()
                                        
                                        player.seek(to: CMTime(seconds: startPos / positionDurationRatio, preferredTimescale: 600), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                                        
                                    })
                                    .onEnded({ _ in
                                        
                                        let timeValue = NSValue(time: CMTime(seconds: endPos / positionDurationRatio, preferredTimescale: 600))
                                        player.addBoundaryTimeObserver(forTimes: [timeValue], queue: nil) {
                                            var time = CMTime()
                                            timeValue.getValue(&time)
                                            //print(String((endPos / positionDurationRatio)))
                                            if abs(CMTimeGetSeconds(time) - (endPos / positionDurationRatio)) < 0.01{
                                                player.pause()
                                            }else{
                                                //print("pass at: \(String(CMTimeGetSeconds(time)))")
                                            }
                                        }
                                        
                                        player.play()
                                    })
                            )
                    )
                    .onChange(of: videoData.duration, perform: { videoDuration in
                        positionDurationRatio = Double(Int(max)) / videoDuration
                        if videoDuration > maxDuration{
                            endPos = maxDuration * positionDurationRatio
                        }else{
                            endPos = max
                        }
                    })
                }
                .background(.white)
                
            }
            .frame(width: UIScreen.main.bounds.width - 80)
            
            HStack{
                
                Button {
                    player.pause()
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                
                Spacer()
                
                Button{
                    
                    player.pause()
                    
                    let startTime = CMTime(seconds: startPos / positionDurationRatio, preferredTimescale: 600)
                    let endTime = CMTime(seconds: endPos / positionDurationRatio, preferredTimescale: 600)
                    
                    videoData.exportVideo(startTime,endTime){ url in
                        DispatchQueue.main.async {
                            newPostData.result.url = url
                        }
                    }
                    
                    DispatchQueue.main.async {
                        newPostData.result.thumbnail = videoData.generateThumbnails(startTime: startTime)
                        newPostData.picker.toggle()
                    }
//
//                    withAnimation(.easeOut) {
//                        dismiss()
//                    }
                    
                    
                    
                } label: {
                    Text("Confirm")
                }

            }
            .padding()
            .frame(width: UIScreen.main.bounds.width - 80)
            
        }
//        .onAppear {
//            isNavigationBarHidden = true
//        }
        .background(Color.black.ignoresSafeArea())
        .modifier(LoadingModifier(isLoading: $videoData.isLoading, transparent: false))
        .navigationBarTitle(Text("Trim Video"), displayMode: .inline)
        .onDisappear {
            dismiss()
        }
//        ZStack{
//            if let errorMessage = videoData.errorMessage{
//                ErrorDismissView(error: errorMessage)
//
//            }else{
//                VStack(alignment: .center){
//
//
//
//                    //var positionDurationRatio = videoData.positionDurationRatio
//                    if videoData.ratio != 0{
//                        EquatableVideoPlayer(player: player, url: url, ratio: videoData.ratio, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 300)
//                            .equatable()
//
//                        Text(String(videoData.ratio))
//                    }
//
//                    GeometryReader{ reader in
//
//                        //scale : Double // scale between length of thumbnails and video length
//
//                        VStack(alignment: .center){
//
//                            let mid = reader.frame(in: .local).midX
//                            let max = reader.frame(in: .local).maxX
//                            let minDurationScaled = minDuration * positionDurationRatio
//                            let maxDurationScaled = maxDuration * positionDurationRatio
//                            //Text(String(Int(predict.x)))
//                            //Text(String(Int(reader.frame(in: .local).minX)))
//
//                            HStack(spacing: 0){
//
//                                ForEach(videoData.thumbnails, id:\.self){ image in
//                                    Image(uiImage: image)
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: videoData.thumbnailHeight * 9 / 16, height: videoData.thumbnailHeight)
//                                        .clipped()
//                                }
//                            }
//                            .frame(width: UIScreen.main.bounds.width - 80, height: videoData.thumbnailHeight, alignment: .center)
//                            .overlay(
//                                DragBar(backColor: .white, frontColor: .gray, height: 60, width: 10)
//                                    .offset(x: startPos - mid, y: 0)
//                                    .gesture(
//                                        DragGesture()
//                                            .onChanged({ gesture in
//
//                                                var position : CGFloat = gesture.translation.width + gesture.startLocation.x + mid
//
//                                                if position < 0{
//                                                    position = 0
//                                                }else if position > (max -  minDurationScaled){
//                                                    position = (max -  minDurationScaled)
//                                                }
//
//                                                startPos = position
//
//                                                if startPos + minDurationScaled > endPos{
//                                                    endPos = startPos + minDurationScaled
//                                                }
//
//                                                if startPos + maxDurationScaled < endPos{
//                                                    endPos = startPos + maxDurationScaled
//                                                }
//
//                                                player.pause()
//
//                                                player.seek(to: CMTime(seconds: startPos / positionDurationRatio, preferredTimescale: 600), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
//
//
//                                            })
//                                            .onEnded({ _ in
//
//                                                let timeValue = NSValue(time: CMTime(seconds: endPos / positionDurationRatio, preferredTimescale: 600))
//                                                player.addBoundaryTimeObserver(forTimes: [timeValue], queue: nil) {
//                                                    //print("pause")
//                                                    var time = CMTime()
//                                                    timeValue.getValue(&time)
//                                                    //print(String((endPos / positionDurationRatio)))
//
//                                                    if abs(CMTimeGetSeconds(time) - (endPos / positionDurationRatio)) < 0.01{
//                                                        player.pause()
//                                                    }else{
//                                                        //print("pass at: \(String(CMTimeGetSeconds(time)))")
//                                                    }
//                                                }
//
//                                                player.play()
//                                            })
//                                    )
//                            )
//                            .overlay(
//
//                                DragBar(backColor: .white, frontColor: .gray, height: 60, width: 10)
//                                    .offset(x: endPos - mid, y: 0)
//                                    .gesture(
//                                        DragGesture()
//                                            .onChanged({ gesture in
//
//                                                var position : CGFloat = gesture.translation.width + gesture.startLocation.x + mid
//
//                                                if position < minDurationScaled{
//                                                    position = minDurationScaled
//                                                }else if position > max{
//                                                    position = max
//                                                }
//
//                                                endPos = position
//
//                                                if endPos - minDurationScaled < startPos{
//                                                    startPos = endPos - minDurationScaled
//                                                }
//
//                                                if endPos - maxDurationScaled > startPos{
//                                                    startPos = endPos - maxDurationScaled
//                                                }
//
//                                                player.pause()
//
//                                                player.seek(to: CMTime(seconds: startPos / positionDurationRatio, preferredTimescale: 600), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
//
//                                            })
//                                            .onEnded({ _ in
//
//                                                let timeValue = NSValue(time: CMTime(seconds: endPos / positionDurationRatio, preferredTimescale: 600))
//                                                player.addBoundaryTimeObserver(forTimes: [timeValue], queue: nil) {
//                                                    var time = CMTime()
//                                                    timeValue.getValue(&time)
//                                                    //print(String((endPos / positionDurationRatio)))
//                                                    if abs(CMTimeGetSeconds(time) - (endPos / positionDurationRatio)) < 0.01{
//                                                        player.pause()
//                                                    }else{
//                                                        //print("pass at: \(String(CMTimeGetSeconds(time)))")
//                                                    }
//                                                }
//
//                                                player.play()
//                                            })
//                                    )
//                            )
//                            .onChange(of: videoData.duration, perform: { videoDuration in
//                                positionDurationRatio = Double(Int(max)) / videoDuration
//                                if videoDuration > maxDuration{
//                                    endPos = maxDuration * positionDurationRatio
//                                }else{
//                                    endPos = max
//                                }
//                            })
//                        }
//                        .background(.white)
//
//                    }
//                    .frame(width: UIScreen.main.bounds.width - 80)
//
//                    HStack{
//
//                        Button {
//                            player.pause()
//                            dismiss()
//                        } label: {
//                            Text("Cancel")
//                        }
//
//                        Spacer()
//
//                        Button{
//
//                            player.pause()
//
//                            let startTime = CMTime(seconds: startPos / positionDurationRatio, preferredTimescale: 600)
//                            let endTime = CMTime(seconds: endPos / positionDurationRatio, preferredTimescale: 600)
//
//                            videoData.exportVideo(startTime,endTime){ url in
//                                newPostData.result.url = url
//                            }
//                            newPostData.result.thumbnail = videoData.generateThumbnails(startTime: startTime)
//
//                            newPostData.picker.toggle()
//        //
//        //                    withAnimation(.easeOut) {
//        //                        dismiss()
//        //                    }
//
//
//
//                        } label: {
//                            Text("Confirm")
//                        }
//
//                    }
//                    .padding()
//                    .frame(width: UIScreen.main.bounds.width - 80)
//
//                }
//        //        .onAppear {
//        //            isNavigationBarHidden = true
//        //        }
//                .background(Color.black.ignoresSafeArea())
//                .modifier(LoadingModifier(isLoading: $videoData.isLoading))
//                .navigationBarTitle(Text("Trim Video"), displayMode: .inline)
//
//            }
//        }
//        .onDisappear {
//            dismiss()
//        }
        
        
       
        //.navigationBarTitle("Hidden Title")
        //.navigationBarBackButtonHidden(true)
        
        
    }
}


struct DragBar : View{
    
    var backColor : Color
    var frontColor : Color
    var height : CGFloat
    var width : CGFloat
    
    var body: some View{
        
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(backColor)
            .frame(width: width, height: height, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .foregroundColor(frontColor)
                    .frame(width: width - 8, height: height - 10, alignment: .center)
            )
            .navigationBarHidden(true)
//
    }
    
}


struct VideoTrimmingPreview: PreviewProvider{
    
    static var previews: some View{
        BindingViewPreviewContainer_2(url: URL(string: "file:///Users/xueyaozhou/Library/Developer/CoreSimulator/Devices/82B88E14-59C9-4BD4-B9D3-16C5B2864079/data/Containers/Shared/AppGroup/1284F2AA-0306-4F44-B2BC-7B49BC8E6D1B/File%20Provider%20Storage/photospicker/version=1&uuid=C9D4B867-4651-4E9B-BD7A-087CDD48F179&mode=compatible.mov")!)
            
    }
}

struct BindingViewPreviewContainer_2 : View {

    @StateObject var newPostData : NewPostModel = NewPostModel()
    
    var url : URL

     var body: some View {
         VideoTrimmingView(url: url)
             .environmentObject(newPostData)
     }
}

//func loadVideoAsync()
