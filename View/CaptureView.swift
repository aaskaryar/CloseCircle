////
////  CaptureView.swift
////  ShadeInc
////
////  Created by Aria Askaryar on 4/17/22.
////
//
//import SwiftUI
//
//struct CaptureView: View {
//
//    //@StateObject var model = FrameViewModel()
//    @StateObject var newPostData = NewPostModel()
//    @ObservedObject var settingData : SettingViewModel
//    @ObservedObject var hobbyData : HobbiesViewModel
//
//    @State var currentZoomFactor: CGFloat = 1.0
//
//    var body: some View{
//        GeometryReader { reader in
//
//            CameraPreview(session: model.session)
//                .gesture(
//                    DragGesture().onChanged({ (val) in
//                        //  Only accept vertical drag
//                        if abs(val.translation.height) > abs(val.translation.width) {
//                            //  Get the percentage of vertical screen space covered by drag
//                            let percentage: CGFloat = -(val.translation.height / reader.size.height)
//                            //  Calculate new zoom factor
//                            let calc = currentZoomFactor + percentage
//                            //  Limit zoom factor to a maximum of 5x and a minimum of 1x
//                            let zoomFactor: CGFloat = min(max(calc, 1), 5)
//                            //  Store the newly calculated zoom factor
//                            currentZoomFactor = zoomFactor
//                            //  Sets the zoom factor to the capture device session
//                            model.zoom(with: zoomFactor)
//                        }
//                    })
//                )
//                .onAppear {
//                    model.configure()
//                }
//                .alert(isPresented: $model.showAlertError, content: {
//                    Alert(title: Text(model.alertError.title), message: Text(model.alertError.message), dismissButton: .default(Text(model.alertError.primaryButtonTitle), action: {
//                        model.alertError.primaryAction?()
//                    }))
//                })
//                //.ignoresSafeArea()
//                //.scaledToFill()
//                .overlay(
//                    VStack{
//
//                        HStack{
//                            Text("Capture")
//                                .font(.largeTitle)
//                                .fontWeight(.bold)
//                                .foregroundColor(Color.white)
//                                .bold()
//                                .padding(.leading)
//
//                            Spacer()
//
//                            Button(action: {}) {
//
//                                Color.black
//                                    .opacity(0.8)
//                                    .clipShape(Circle())
//                                    .frame(width: 40, height: 40)
//                                    .overlay(){
//                                        Image(systemName: "camera.fill.badge.ellipsis")
//                                            .foregroundColor(.white)
//                                            .frame(width: 40, height: 40)
//                                    }
//
//                            }
//                        }
//                        .padding(15)
//
//                        Spacer()
//
//                        HStack(alignment: .bottom){
//
//                            VStack{
//
//                                Spacer()
//
//                                Text("Library")
//                                    .font(.footnote)
//                                    .fontWeight(.medium)
//                                    .foregroundColor(.white)
//
//                                Image("Jimmy")
//                                    .resizable()
//                                    .frame(width: 46.67, height: 46.67, alignment: .center)
//                                    .scaledToFill()
//                                    .clipped()
//                                    .cornerRadius(10)
//                                    .background(
//                                        Color.white
//                                            .frame(width: 49, height: 49)
//                                            .cornerRadius(10)
//                                    )
//
//
//                            }
//
//                            Spacer()
//
//                            VStack{
//
//                                Spacer()
//
//                                Button(action: {model.capturePhoto()}){
//
//                                    Color.white
//                                        .clipShape(Circle())
//                                        .frame(width: 90, height: 90)
//                                        .overlay(){
//                                            Image(systemName:"camera.fill")
//                                                .resizable()
//                                                .scaledToFill()
//                                                .frame(width: 30, height: 30)
//                                                .foregroundColor(.gray)
//                                                .opacity(0.9)
//                                        }
//
//                                }
//                                //.padding()
//                            }
//
//                            Spacer()
//
//                            VStack{
//
//                                Button(action: {model.switchFlash()}){
//
//                                    Color.black
//                                        .opacity(0.8)
//                                        .frame(width: 40, height: 64, alignment: .center)
//                                        .clipShape(Capsule())
//                                        .overlay(){
//                                            Image(systemName: model.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
//                                                .frame(width: 16, height: 24, alignment: .center)
//                                                .foregroundColor(.white)
//                                        }
//
//
//                                }
//                                .padding(.bottom, 10)
//                                //Spacer(minLength: 15)
//
//                                Button(action: {model.flipCamera()}){
//
//                                    Color.black
//                                        .opacity(0.8)
//                                        .frame(width: 40, height: 40, alignment: .center)
//                                        .clipShape(Circle())
//                                        .overlay(){
//                                            Image(systemName:"arrow.triangle.2.circlepath")
//                                                .frame(width: 30, height: 30, alignment: .center)
//                                                .foregroundColor(.white)
//                                        }
//
//                                }
//
//                            }
//                            //frame(height: 140)
//
//                        }
//                        .padding(15)
//                        .padding(.bottom, 20)
//                    }
//                )
//        }
//    }
//}
