//
//  SettingsView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/1/22.
//

import SwiftUI
import SDWebImageSwiftUI
struct SettingsView: View {
    
    //var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @State private var image = UIImage()
    @State private var showSheet = false
    @State var hobbyToDelete : HobbyModel?
    @State var hobbyToEdit : HobbyModel?
    @State var editHobby : Bool = false
    @ObservedObject var settingsData : SettingViewModel
    @ObservedObject var hobbyData : HobbiesViewModel
    @ObservedObject var postData : PostViewModel
    @EnvironmentObject var viewModel: RegistrationViewModel
    @Environment(\.colorScheme) var colorScheme

    @Environment(\.presentationMode) var presentationMode: Binding <PresentationMode>
    
    var newPostData: NewPostModel
    var searchData: SearchViewModel
   
    var body: some View {
       
       NavigationView{
          VStack{
              
//             HStack{
//
//                Text(settingsData.userInfo.username)
//                   .font(Font.custom("DM Sans", size: 36))
//                   .bold()
//                   .foregroundColor(Color.black)
//                   .padding(.leading)
//
//                Spacer()
//
//                 HStack{
//
//                    NavigationLink(destination: EditProfileView(settingsData: settingsData).navigationBarHidden(true).navigationBarBackButtonHidden(true)){
//
//                       Image("edit_profile")
//                          .resizable()
//                          .scaledToFill()
//                          .frame(width: 19, height: 15)
//                          .background(Color(hex: 0xE7E9EE)
//                                        .clipShape(Circle())
//                                        .frame(width: 40, height: 40)
//                          )
//                          .foregroundColor(.black)
//                          //.frame(width: 19, height: 15)
//                    }
//                    .padding(.trailing)
//
//                     NavigationLink(destination: ChangeSettingView(settingsData: settingsData).navigationBarHidden(true).navigationBarBackButtonHidden(true)){
//
//                       Image(systemName: "gearshape.fill")
//                          .background(Color(hex: 0xE7E9EE)
//                                        .clipShape(Circle())
//                                        .frame(width: 40, height: 40)
//                          )
//                          .foregroundColor(.black)
//                          .frame(width: 40, height: 40)
//                    }
//
//
//                 }
//                 .padding(.trailing)
//
//
//
//
//
//   //             Button(action: {}) {
//   //
//   //                Image(systemName: "gearshape.fill")
//   //                   .background(Color(hex: 0xE7E9EE)
//   //                                 .clipShape(Circle())
//   //                                 .frame(width: 40, height: 40)
//   //                   )
//   //                   .foregroundColor(.black)
//   //                   .frame(width: 40, height: 40)
//   //             }
//   //             .padding(.trailing)
//
//             }
//             .padding(.top, 20)
//             .padding(.horizontal)
//             .padding(.bottom, 5)
             //.padding(.top, 50)
            // .frame(width: UIScreen.main.bounds.width-30, height: 40, alignment: .top)
             
              ZStack{
                  
                  EquatableWebImage(url: settingsData.userInfo.imageurl, size: 101, shape: Circle())
                      .equatable()
                      .padding(5)
                  
                  HStack{
                      
                      Spacer()
                      
                      VStack{
                          
                          NavigationLink(destination: ChangeSettingView(settingsData: settingsData).navigationBarHidden(true).navigationBarBackButtonHidden(true)){
                              
                              Image(systemName: "gearshape.fill")
                                 .background(
                                    Color(hex: 0xE7E9EE)
                                        .clipShape(Circle())
                                        .frame(width: 40, height: 40)
                                 )
                                 .foregroundColor(.black)
                                 .frame(width: 40, height: 40)
                          }
                          .padding(.bottom)
                          
                          NavigationLink(destination: EditProfileView(settingsData: settingsData).navigationBarHidden(true).navigationBarBackButtonHidden(true)){
                          
                              Image("edit_profile")
                                 .resizable()
                                 .scaledToFill()
                                 .frame(width: 19, height: 15)
                                 .background(
                                    Color(hex: 0xE7E9EE)
                                        .clipShape(Circle())
                                        .frame(width: 40, height: 40)
                                 )
                                 .foregroundColor(.black)
                                 
                           }
                          
                          Spacer()
                      }
                      .padding()
                  }
              }
              .frame(height: 120, alignment: .center)
             
             Text(settingsData.userInfo.real_name == "" ? "Full Name" : settingsData.userInfo.real_name)
                .font(Font.custom("DMSans-Bold", size: 16))
                .padding(.bottom, 10)
                //.padding(.vertical)
             
//             Text(settingsData.userInfo.bio)
//                .font(Font.custom("DM Sans", size: 12))
//                .foregroundColor(Color.black)
//                .padding(.bottom, 10)
//
             
              HStack{
                 
                 VStack{
                    
                    Text("Hobbies")
                       .font(Font.custom("DM Sans", size: 14))
                       .fontWeight(.medium)

                     Text(String(settingsData.userInfo.myHobbies.count))
                       .font(Font.custom("DM Sans", size: 20))
                       .fontWeight(.bold)
                    
                 }
                 .frame(width: 80)
                 .foregroundColor(colorScheme == .dark ? .white : .black)
                 
                 Spacer()
                  
                  NavigationLink(destination:FollowerView().navigationBarHidden(true).navigationBarBackButtonHidden(true)){
                      
                      VStack{
                         
                         Text("Followers")
                            .font(Font.custom("DM Sans", size: 14))
                            .fontWeight(.medium)

                          Text(String(settingsData.userInfo.followerUsers.count))
                            .font(Font.custom("DM Sans", size: 20))
                            .fontWeight(.bold)
                         
                      }
                      .frame(width: 70)
                      .foregroundColor(colorScheme == .dark ? .white : .black)
                      
                  }
                 
                 
                 
                 Spacer()
                  
                  NavigationLink(destination: FollowingView(hobbyFocused: "")
                                   .navigationBarHidden(true).navigationBarBackButtonHidden(true)){

                      VStack{

                         Text("Following")
                            .font(Font.custom("DM Sans", size: 14))
                            .fontWeight(.medium)

                          Text(String(settingsData.userInfo.followingUsers.count))
                            .font(Font.custom("DM Sans", size: 20))
                            .fontWeight(.bold)

                      }
                      .frame(width: 70)
                      .foregroundColor(colorScheme == .dark ? .white : .black)

                  }

              }
              .padding(.horizontal, 20)
              
              HobbiesView(hobbyData: hobbyData, postData: postData, hobbyToDelete: $hobbyToDelete, hobbyToEdit: $hobbyToEdit)
             
             
              NavigationLink(destination: HobbyDetailView()
                               .navigationBarHidden(true)
                               .navigationBarBackButtonHidden(true)
                             , isActive: $hobbyData.detail)
              { EmptyView() }
              
//              NavigationLink(destination: HobbyEditView(hobby: hobbyToEdit), isActive: $editHobby) {
//                  EmptyView()
//              }

             
             
          }
          .background(Color.white.ignoresSafeArea())
          .sheet(isPresented: $settingsData.picker) {

              ImagePicker(picker: $settingsData.picker, img_Data: $settingsData.img_data)
          }.fullScreenCover(isPresented: $hobbyData.newHobby) {
              
              NewHobby()
          }
          .navigationBarHidden(true)
          .alert(item: $hobbyToDelete) { hobby in
              Alert(title: Text("Delete Hobby"), message: Text("Are you sure to delete hobby \(hobby.name), you can never find the posts back"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Yes"), action: {
                  hobbyData.deleteHobby(id: hobby.id)
              }))
              
          }
//          .onChange(of: hobbyToEdit) { hobby in
//              if hobby != HobbyModel.emptyHobby{
//                  editHobby = true
//              }
//              hobbyToEdit = HobbyModel.emptyHobby
//          }
          .fullScreenCover(item: $hobbyToEdit) { hobby in
              
              if let hobby = hobby{
                  HobbyEditView(hobby: hobby)
              }
          }
       }
    }

}


