//
//  VideoDownloadModel.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 8/2/22.
//

import Foundation
import Firebase

class VideoCacheModel : ObservableObject{
    
//    var url: URL
//    var uid: String
//    var pid: String
    @Published var isLoading = true
    @Published var errorMessage : String = ""
    @Published var percentComplete: Double = 0.0
    var downloadTask: StorageDownloadTask?
    private let fileManager = FileManager.default
    private let cachesDirectoryUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    private var maximumVideoNum = 5
    private var cacheEntries : Queue<String> = Queue<String>()
    
    init(){
        let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for fileURL in fileURLs where fileURL.pathExtension == "mp4" {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  { print(error) }
    }
    
    deinit{
        while let path = cacheEntries.dequeue(){
            if fileManager.fileExists(atPath: path){
                deleteVideo(path: path)
            }
        }
    }
    
    func getVideo(uid: String, pid: String, completion: @escaping (URL?) -> ()){
        //if cacheEntries.contains(pid)
        isLoading = true
        let fileUrl = cachesDirectoryUrl.appendingPathComponent("\(pid).mp4")
        let filePath = fileUrl.path
        if !fileManager.fileExists(atPath: filePath) {
            let contents = Data()
            fileManager.createFile(atPath: filePath, contents: contents)
            print("File \(filePath) created")
            
            if cacheEntries.count == maximumVideoNum{
                if(!deleteVideo(path: cacheEntries.dequeue())){
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
            
            cacheEntries.enqueue(filePath)
            // Create a reference to the file you want to download
            let videoRef = storage.reference().child("post_Videos/\(uid)/\(pid)")

            // Download to the local filesystem
            downloadTask = videoRef.write(toFile: fileUrl) { url, error in
                if let error = error {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(url)
                        self.isLoading = false
                    }
                }
            }
            
            downloadTask!.observe(.progress) { snapshot in
              // Download reported progress
                self.percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            }
            
            downloadTask!.observe(.failure) { snapshot in
                guard let errorCode = (snapshot.error as? NSError)?.code else {
                    return
                }
                guard let error = StorageErrorCode(rawValue: errorCode) else {
                    return
                }
                
                self.errorMessage = ""
                self.errorMessage = "\(errorCode)"
                self.isLoading = false
                self.cancelTask()
            }
            
        } else {
            print("File \(filePath) already exists")
            DispatchQueue.main.async {
                completion(fileUrl)
                self.isLoading = false
            }
        }
    }
    
    func deleteVideo(path: String?) -> Bool{
        
        guard let path = path else {
            return false
        }
        do {
            try fileManager.removeItem(atPath: path)
            return true
        } catch {
            print("ERROR DESCRIPTION: \(error)")
            return false
        }
    }
    
    func cancelTask(){
        if let downloadTask = downloadTask {
            downloadTask.cancel()
            downloadTask.removeAllObservers()
            
        }
        downloadTask = nil
    }
}
