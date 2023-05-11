//
//  SettingsView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/1/22.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
struct SearchSettingsView: View {
    
    //var edges = UIApplication.shared.windows.first?.safeAreaInsets
//    @State private var showSheet = false
//    @ObservedObject var settingsData : SettingViewModel
//    @ObservedObject var hobbyData : HobbiesViewModel
//    @ObservedObject var postData : PostViewModel
    @StateObject var searchUserData : SearchUserModel
    //@State var hobbyOnFocus : HobbyModel?
//    @State private var UserListener : ListenerRegistration?
//    @State private var HobbiesListener : ListenerRegistration?
    @Environment(\.presentationMode) var presentationMode: Binding <PresentationMode>
    var userInfo: UserModel
    
    init(userInfo: UserModel){
        _searchUserData = StateObject(wrappedValue: SearchUserModel(userInfo: userInfo))
        self.userInfo = userInfo
    }
    
    var body: some View {
       
       NavigationView{
           
          VStack{
              
              ZStack{
                  
                  VStack{
                      
                      HStack{
                          
                          Button(action: {
                              presentationMode.wrappedValue.dismiss()
                          }) {
                              Image(systemName: "arrow.backward")
                                  .resizable()
                                  .scaledToFit()
                                  .frame(width: 30, height: 30)
                                  .foregroundColor(.black)
                          }
                          .padding()
                          
                          Spacer()
                      }
                      
                      Spacer()
                  }
                  
                  EquatableWebImage(url: searchUserData.userInfo.imageurl, size: 101, shape: Circle())
                      .equatable()
                  
              }
              .padding(.top)
              .padding(.horizontal)
              .padding(.bottom, 5)
              .frame(height: 110)
              
             //.padding(.top, 50)
            // .frame(width: UIScreen.main.bounds.width-30, height: 40, alignment: .top)
             
             
             
             .padding(5)
             
             
             Text(searchUserData.userInfo.real_name == "" ? "Full Name" : searchUserData.userInfo.real_name)
                .font(Font.custom("DMSans-Bolds", size: 16))
                .padding(.bottom, 15)

            // Randi
   //         let exampleColor : Color = Color(red: 63/255, green: 63/255, blue: 104/255)
   //         VStack{
            // Randi
              
             
              HStack{
                 
                 VStack{
                    
                    Text("Hobbies")
                       .font(Font.custom("DM Sans", size: 14))
                       .fontWeight(.medium)

                    Text(String(searchUserData.hobbies.count))
                       .font(Font.custom("DM Sans", size: 20))
                       .fontWeight(.bold)
                    
                 }
                 
                 Spacer()
                  
                  NavigationLink(destination:SearchFollowingView(userInfo: userInfo).navigationBarHidden(true).navigationBarBackButtonHidden(true)){
                      
                      VStack{
                         
                         Text("Following")
                            .font(Font.custom("DM Sans", size: 14))
                            .fontWeight(.medium)

                          Text(String(searchUserData.userInfo.followingUsers.count))
                            .font(Font.custom("DM Sans", size: 20))
                            .fontWeight(.bold)
                         
                      }
                      .foregroundColor(.black)
                  }
                 
                 
                 
                  Spacer()
                  
                  NavigationLink(destination:SearchFollowerView(userInfo: userInfo).navigationBarHidden(true).navigationBarBackButtonHidden(true)){
                      VStack{
                         
                         Text("Follower")
                            .font(Font.custom("DM Sans", size: 14))
                            .fontWeight(.medium)

                          Text(String(searchUserData.userInfo.followerUsers.count))
                            .font(Font.custom("DM Sans", size: 20))
                            .fontWeight(.bold)
                         
                      }
                      .foregroundColor(.black)
                  }
                  
                  
                 
              }
              .padding(.horizontal, 20)
              
              RoundedRectangle(cornerRadius: 25)
                  .shadow(color: .black.opacity(0.1), radius: 4)
                  .foregroundColor(.white)
                  .overlay(
                    VStack{
                       
                       HStack{
                          
                          Text("Hobbies")
                             .font(Font.custom("DM Sans", size: 20))
                             .fontWeight(.bold)
                             .lineLimit(1)
                          
                          Spacer()
                           
                           Button(action: {}){
                               Text("Invite to Follow")
                                  .foregroundColor(.white)
                                  .font(Font.custom("DM Sans", size: 14))
                                  .fontWeight(.bold)
                                  .lineLimit(1)
                                  .background(
                                    Constants.ShadeGreen
                                       .frame(width: 127, height: 31, alignment: .center)
                                       .cornerRadius(9)
                                  )
                           }
                           .padding(.trailing, 20)
                          
                          
                       }
                       .padding(.horizontal, 30)
                       .padding(.vertical, 10)
                       .padding(.top, 12)
          
                       
                        SearchHobbiesView(searchUserData: searchUserData)
                       
//                        NavigationLink(destination: SearchHobbyDetail(searchUserData: searchUserData)
//                                         .navigationBarHidden(true)
//                                         .navigationBarBackButtonHidden(true)
//                                         .onDisappear(perform: {
//                                             searchUserData.detail = false
//                                         })
//                                       , isActive: $searchUserData.detail)
//                        { EmptyView() }
                       
                      //Spacer()
                       
                    }
                    .navigationBarHidden(true)
                  )
             
             
          }
          .background(Color.white)
          .navigationBarHidden(true)
       }
       .fullScreenCover(item: $searchUserData.hobbyOnFocus) { hobby in
           SearchHobbyDetail(userInfo: searchUserData.userInfo, hobby: hobby)
       }
    }

}


