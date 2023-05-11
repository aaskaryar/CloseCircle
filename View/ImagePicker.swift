//
//  ImagePicker.swift
//  Social App
//
//  Created by Balaji on 14/09/20.
//

import SwiftUI
import PhotosUI

struct ImageVideoPicker : UIViewControllerRepresentable {
    
    @Binding var picker : Bool
    @Binding var progress : Progress?
    @Binding var result : imagePickingResult
    
    func makeCoordinator() -> Coordinator {
        return ImageVideoPicker.Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        
        let controller = PHPickerViewController(configuration: config)
        
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
        
    }
    
    class Coordinator : NSObject,PHPickerViewControllerDelegate{
        
        var parent : ImageVideoPicker
        
        init(parent : ImageVideoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            if results.isEmpty{
                self.parent.picker.toggle()
                return
            }
            
            let item = results.first!.itemProvider
            
            if item.canLoadObject(ofClass: UIImage.self){
                
                item.loadObject(ofClass: UIImage.self) { (image, err) in
                    if err != nil{
                        return
                    }
                    
                    let imageData = image as! UIImage
                    
                    print("good pick")
                    
                    DispatchQueue.main.async {
                        self.parent.result.url = nil
                        self.parent.result.img_Data = imageData.jpegData(compressionQuality: 0.5)!
                        self.parent.result.count += 1
                        //self.parent.picker.toggle()
                    }
                }
            }
            else if item.hasItemConformingToTypeIdentifier(UTType.movie.identifier){
                
                item.loadItem(forTypeIdentifier: UTType.movie.identifier, options: [:]) { [self] (videoURL, error) in
                    print("result:", videoURL, "\nerr:", error)

                    if let url = videoURL as? URL {
                        
//                        let path = videoURL.path
//                        let url = NSURL(fileURLWithPath: path)
                        
                       // print(AVAsset(url: videoURL).status(of: .))
                        if AVAsset(url: url).isPlayable{
                            DispatchQueue.main.async {
                                self.parent.result.url = url
                                self.parent.result.img_Data = nil
                                self.parent.result.count += 1
                            }
                        }else{
                            self.parent.progress = item.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { _, error in
                                DispatchQueue.main.async {
                                    self.parent.result.url = url
                                    self.parent.result.img_Data = nil
                                    self.parent.result.count += 1
                                }
                            }
                        }
                    }
                }
                
                
            
//
//                item.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { _, err in
////                    print("resullt:", url, "\nerr: ", err)
////                    DispatchQueue.main.async {
////                        self.parent.result.url = url
////                        self.parent.result.img_Data = nil
////                        self.parent.result.count += 1
////                    }
//                    item.loadItem(forTypeIdentifier: UTType.movie.identifier, options: [:]) { [self] (videoURL, error) in
//                        print("resullt:", videoURL, "\nerr:", error)
//                        DispatchQueue.main.async {
//                            if let url = videoURL as? URL {
//    //                            let urlSt1`ring: String = url.absoluteString!
//    //                            let realUrl = URL(fileURLWithPath: urlString)
//                                DispatchQueue.main.async {
//                                    self.parent.result.url = url
//                                    self.parent.result.img_Data = nil
//                                    self.parent.result.count += 1
//                                }
//                                //self.parent.picker.toggle()
//                            }
//                        }
//                    }
//                }
            }
        }
    }
}

struct ImagePicker : UIViewControllerRepresentable {
    
    @Binding var picker : Bool
    @Binding var img_Data : Data
    
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let controller = PHPickerViewController(configuration: config)
        
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
        
    }
    
    class Coordinator : NSObject,PHPickerViewControllerDelegate{
        
        var parent : ImagePicker
        
        init(parent : ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            if results.isEmpty{
                self.parent.picker.toggle()
                return
            }
            
            let item = results.first!.itemProvider
            
            if item.canLoadObject(ofClass: UIImage.self){
                
                item.loadObject(ofClass: UIImage.self) { (image, err) in
                    if err != nil{return}
                    
                    let imageData = image as! UIImage
                    
                    print("good pick")
                    
                    DispatchQueue.main.async {
                        self.parent.img_Data = imageData.jpegData(compressionQuality: 0.5)!
                        self.parent.picker.toggle()
                    }
                }
            }
        }
    }
}

struct imagePickingResult: Equatable, Identifiable{
    var id = UUID()
    var img_Data : Data?
    var url : URL?
    var count : Int = 0
    var thumbnail: UIImage?
    
    func isEmpty() -> Bool{
        return self.img_Data == nil && self.url == nil
    }
}


func exportVideo(url: URL, completion: @escaping (URL?) -> ()){
    
    let asset = AVURLAsset(url: url)
    
    guard let outputMovieURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("preview.mov") else{
        DispatchQueue.main.async {
            completion(nil)
        }
        return
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
//

    //create exporter  
    let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetLowQuality)

    //configure exporter
    exporter?.outputURL = outputMovieURL
    exporter?.outputFileType = .mp4

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
        }
    })
}
