//
//  VideoViewModel.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/29/22.
//

import Foundation
import AVFoundation
import UIKit

class VideoViewModel: ObservableObject{
    
    @Published var isLoading = false
    @Published var duration : Double = 0
    @Published var ratio : Double = 0
    @Published var thumbnails : [UIImage] = [UIImage]()
    @Published var errorMessage : String?
    var asset : AVAsset
    var thumbnailHeight : CGFloat = 60
    
    init(url: URL){
        asset = AVAsset(url: url)
        loadVideo()
    }
    
//    deinit{
//        thumbnails = [UIImage]()
//    }
    
    func generateThumbnails(startTime: CMTime) -> UIImage?{
         
        let thumbnailGenerator = AVAssetImageGenerator(asset: asset)
        thumbnailGenerator.appliesPreferredTrackTransform = true
         
        do{
            let cgImage = try thumbnailGenerator.copyCGImage(at: startTime, actualTime: nil)
            return UIImage(cgImage: cgImage)
            
        }catch{
            print(error)
            return nil
        }
     }
    
    func loadVideo(){
        isLoading = true
        
        Task.init {
            
            do{

                
                let (tracks, dura) = try await asset.load(.tracks, .duration)
                
                guard let track = tracks.first else {return}
                
                let size = track.naturalSize.applying(track.preferredTransform)
                
                DispatchQueue.main.async {
                    
                    self.duration = CMTimeGetSeconds(dura)
                    
                    self.ratio = abs(size.width) / abs(size.height)
                    
                    self.generateThumbnails()
                }
                
            }catch{
                
                switch asset.status(of: .metadata) {
                case .notYetLoaded:
                    print("1")
                    // The initial state of a property.
                case .loading:
                    print("2")
                    // The asset is actively loading the property value.
                case .loaded(let metadata):
                    print("3")
                    // The property is ready to use.
                case .failed(let error):
                    print(error.localizedFailureReason)
                    // The property value fails to load.
                }
                
                DispatchQueue.main.async {
                    self.errorMessage = "\(error.localizedDescription)"
                }
                
                
                print(error.localizedDescription)
                
            }
           
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
        }
        
        //isLoading = false
    }
    
    func generateThumbnails(){
        
       // let widthPerThumbnail = 100 * ratio
        
        thumbnailHeight = (UIScreen.main.bounds.width - 80) / 10 / 9 * 16
        
        //let thumbnailsTotalNum : Int = Int((UIScreen.main.bounds.width - 80) / (thumbnailHeight * 9 / 16))
        
        let thumbnailsTotalNum = 10
        
        let durationPerThumbnail : Double = duration / Double((thumbnailsTotalNum - 1))
        
        let thumbnailGenerator = AVAssetImageGenerator(asset: asset)
        
        for i in 0...(thumbnailsTotalNum - 1) {
            
            let durationValue = Double(i) * durationPerThumbnail
            
            do{
                let cgImage = try thumbnailGenerator.copyCGImage(at: CMTime(seconds: durationValue, preferredTimescale: 600), actualTime: nil)
                let UiImage = UIImage(cgImage: cgImage)
                thumbnails.append(UiImage)
            }
            catch{
                print(error)
            }
        }
    }
    
    func exportVideo( _ startTime: CMTime?, _ endTime: CMTime?, completion: @escaping (URL?) -> ()){
        
        isLoading = true

        
        guard let outputMovieURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("exported.mov") else{
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        var timeRange : CMTimeRange? = nil
        
        if let startTime = startTime, let endTime = endTime {
            timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: endTime)
        }
            //delete any old file
        if FileManager.default.fileExists(atPath: outputMovieURL.path){
            do {
                try FileManager.default.removeItem(at: outputMovieURL)
            } catch {
                print("Could not remove file \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
        }

        //create exporter
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)

        //configure exporter
        exporter?.outputURL = outputMovieURL
        exporter?.outputFileType = .mp4
        
        if let timeRange = timeRange{
            exporter?.timeRange = timeRange
        }

        //export!
        exporter?.exportAsynchronously(completionHandler: { [weak exporter] in
            DispatchQueue.main.async {
                if let error = exporter?.error {
                    print("failed \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    print("Video saved to \(outputMovieURL)")
                    DispatchQueue.main.async {
                        completion(outputMovieURL)
                    }
                }
                
                self.isLoading = false
            }
        })
    }
}
