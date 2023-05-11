//
//  EditProfileView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/28/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var settingsData : SettingViewModel
    @State var editing = false
    @State var editing_row = ""
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                HStack{
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                            .padding(.trailing, 5)
                    }
                    
                    Text("Edit Profile")
                        .font(Font.custom("DM Sans", size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                }
                .padding(.all, 20)
                
                
                ZStack{
                   if settingsData.userInfo.imageurl != ""{
                       let scale = UIScreen.main.scale // Will be 2.0 on 6/7/8 and 3.0 on 6+/7+/8+ or later
                       let thumbnailSize = CGSize(width: 201 * scale, height: 201 * scale) // Thumbnail w

                       WebImage(url:  URL(string: settingsData.userInfo.imageurl)!, context: [.imageThumbnailPixelSize : thumbnailSize])
                           .resizable()
                           .aspectRatio(contentMode: .fill)
                          //.ignoresSafeArea()
                          //.frame(width: UIScreen.main.bounds.size.width, alignment: .top)
                          
                      
                       if settingsData.isLoading{
                          ProgressView()
                             .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
                          
                       }
                       
                    }else{
                       Image("default")
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          //.ignoresSafeArea()
         //                 .frame(width: UIScreen.main.bounds.size.width, height:300, alignment: .center)
         //                 .clipped()
         //                 .contentShape(Rectangle())
                    }
                }
                .frame(width: 201, height:201, alignment: .center)
                //.clipped()
                .clipShape(Circle())
                .contentShape(Circle())
                .padding(5)
                .overlay(
                    VStack{
                        
                        Spacer(minLength: 201 - 25)
                        
                        HStack{
                            
                            Spacer(minLength: 201 - 25)
                            
                            Button(action: {settingsData.picker.toggle()}){
                                
                                Color(hex: 0xE4E7EC)
                                    .clipShape(Circle())
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .overlay(
                                        Image(systemName: "square.and.pencil")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.black)
                                            .frame(width: 20, height: 20)
                                    )
                                
                                
                                
                            }
                        }
                    }
                )
                
                NavigationLink( destination:EditingView(settingsData: settingsData, name: "Full Name", operation: settingsData.updateRealName(value:))
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)
                ){
                    
                    EditNaviButton(type: "Full Name", value: settingsData.userInfo.real_name)
                    
                }
                .padding(.top, 20)
                
                NavigationLink( destination:EditingView(settingsData: settingsData, name: "Username", operation: settingsData.updateUserName(value:))
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)
                ){
                    
                    EditNaviButton(type: "Username", value: settingsData.userInfo.username)
                    
                }
                .padding(.top, 20)
                
//                NavigationLink( destination:EditingView(settingsData: settingsData, name: "bio", operation: settingsData.updateUser(type:value:))
//                                    .navigationBarHidden(true)
//                                    .navigationBarBackButtonHidden(true)
//                ){
//
//                    EditNaviButton(type: "bio", value: settingsData.userInfo.bio)
//
//                }
                
                Spacer()
            }
            .onChange(of: settingsData.img_data) { (newData) in
                // whenever image is selected update image in Firebase...
                settingsData.updateImage()
            }
            .navigationBarHidden(true)
            .alert(item: $settingsData.editProfileAlertInfo) { info in
                Alert(title: Text(info.Title), message: Text(info.Message), dismissButton: .cancel(Text("Ok")))
            }
            
        }
        
    }
}

