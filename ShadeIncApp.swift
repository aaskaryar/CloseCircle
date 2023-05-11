//
//  ShadeIncApp.swift
//  ShadeInc

import SwiftUI
import Firebase
import SDWebImage
import SDWebImageSwiftUI

@main
struct ShadeIncApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)   var appDelegagte
    var body: some Scene {
        WindowGroup {
            let viewModel = RegistrationViewModel()
            
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate{
    
    var orientationLock = UIInterfaceOrientationMask.all

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        //Firebase.database.setPersistenceEnabled(true)
        Database.database().isPersistenceEnabled = true
        
        // Add default HTTP header
        SDWebImageDownloader.shared.setValue("image/webp,image/apng,image/*,*/*;q=0.8", forHTTPHeaderField: "Accept")
        
        // Add multiple caches
        let cache = SDImageCache(namespace: "DiskHeavy")
        cache.config.maxMemoryCost = 500 * 1024 * 1024 // 500MB memory
        cache.config.maxDiskSize = 5000 * 1024 * 1024 // 5000MB disk
        SDImageCachesManager.shared.caches = [cache]
        SDWebImageManager.defaultImageCache = SDImageCachesManager.shared
//        let cache1 = SDImageCache(namespace: "cache1")
//        let cache2 = SDImageCache(namespace: "cache2")
//        SDImageCachesManager.shared.caches = [cache1, cache2]
//        SDImageCachesManager.shared.storeOperationPolicy = .concurrent // When any `store` method called, both of cache 1 && cache 2 will be stored in concurrently
//
//        // Assign cache to manager
//        let manager = SDWebImageManager(cache:SDImageCachesManager.shared, loader:SDWebImageDownloader.shared)
//        // Start use

        // If you want to assign cache to default manager, use `defaultImageCache` class property before shared manager initialized
        SDWebImageManager.defaultImageCache = SDImageCachesManager.shared
        return true
    }
    
    struct AppUtility {
        
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
            
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
}

