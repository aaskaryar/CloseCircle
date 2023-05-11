////
////  FrameViewModel.swift
////  ShadeInc
////
////  Created by Macbook on 4/19/22.
////
//import SwiftUI
//import Combine
//import AVFoundation
//
//class FrameViewModel: ObservableObject {
//    private let service = CameraManager()
//
//        @Published var photo: Photo!
//
//        @Published var showAlertError = false
//
//        @Published var isFlashOn = false
//
//        @Published var isCapturing = false
//
//        var alertError: AlertError!
//
//        var session: AVCaptureSession
//
//        private var subscriptions = Set<AnyCancellable>()
//
//        init() {
//            self.session = service.session
//
//            service.$photo.sink { [weak self] (photo) in
//                guard let pic = photo else { return }
//                self?.photo = pic
//            }
//            .store(in: &self.subscriptions)
//
//            service.$shouldShowAlertView.sink { [weak self] (val) in
//                self?.alertError = self?.service.alertError
//                self?.showAlertError = val
//            }
//            .store(in: &self.subscriptions)
//
//            service.$flashMode.sink { [weak self] (mode) in
//                self?.isFlashOn = mode == .on
//            }
//            .store(in: &self.subscriptions)
//        }
//
//        func configure() {
//            service.checkForPermissions()
//            service.configure()
//        }
//
//        func capturePhoto() {
//            service.capturePhoto()
//        }
//
//        func flipCamera() {
//            service.changeCamera()
//        }
//
//        func zoom(with factor: CGFloat) {
//            service.set(zoom: factor)
//        }
//
//        func switchFlash() {
//            service.flashMode = service.flashMode == .on ? .off : .on
//        }
//}
