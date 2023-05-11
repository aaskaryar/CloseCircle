//
//  FollowerView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 5/24/22.
//

import SwiftUI
import SDWebImageSwiftUI
import UIKit

struct FollowerView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var followerData : FollowerViewModel
    @State var hobbyFocused : HobbyModel = HobbyModel.emptyHobby
    @State var UserToFocus : UserModel?
    @State var toggle = false
    var only1Hobby : Bool = false
//    @State var alertDetails: unfollowAlertDetail?
//    @State var previousDetails : unfollowAlertDetail?

    var body: some View {

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

                Text("Followers")
                    .font(Font.custom("DM Sans", size: 29))
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Spacer()

            }
            .padding(.vertical, 20)

            ScrollView(.horizontal,showsIndicators: false){

                HStack{

                    ForEach(0..<followerData.hobbies.count, id: \.self) { index in

                        let hobby : HobbyModel = followerData.hobbies[index]
                        
                        VStack(spacing: UIScreen.main.bounds.width * 0.026){

                            Button(action:{
                                if(!toggle){
                                    toggle.toggle()
                                    hobbyFocused = hobby
                                    // if untoggled, toggle this hobby
                                }else{
                                    // if already toggled, change hobbyfocuesd if different
                                    if(hobby != hobbyFocused){
                                        print("Change")
                                        hobbyFocused = hobby
                                    }else{
                                        toggle.toggle()
                                        hobbyFocused = HobbyModel.emptyHobby
                                        print("toggle")
                                    }
                                }

                            }){

                                HobbyPic(frame: UIScreen.main.bounds.width * 0.13, hobby: hobby.name, backgroundColor: (hobby == hobbyFocused) ? Constants.ShadeGreen : Constants.ShadeGray, foregroundColor: (hobby == hobbyFocused) ? .white : .black)
                            }
                            .disabled(only1Hobby)

                            Text(hobby.name)
                                .font(Font.custom("DM Sans", size: UIScreen.main.bounds.width * 0.026))
                                .fontWeight(.bold)
                                .foregroundColor(.black)

                        }
                        .opacity((only1Hobby && hobby != hobbyFocused) ? 0 : 1)
                        .frame(maxWidth: (only1Hobby && hobby != hobbyFocused) ? 0 : .infinity)

                    }

                }

            }
            
            if followerData.Followers.isEmpty{
                Text("no followers")
                    .font(Font.custom("DM Sans", size: 15))
            }else{
                ScrollView{

                    VStack{

                        ForEach(followerData.Followers.map({$0.key}), id: \.self) { uid in
                            
                            Button {
                                self.UserToFocus = followerData.Followers[uid]
                            } label: {
                                if(!toggle || followerData.FollowersHobbyIdDic[uid]!.contains(hobbyFocused.id)){

                                    FollowerColumn(followerData: followerData, uid: uid, hobby: toggle ? hobbyFocused : HobbyModel.emptyHobby)
                                        .foregroundColor(.black)

                                }else{
                                    EmptyView()
                                }
                            }
                        }
                    }
                }
            }

            

            Spacer()

        }
//        .alert(item: $alertDetails, content: DeleteAlertBuilder)
        //.alert(item: $alertDetails, content: DeleteAlertBuilder)
        .onAppear(){
            if(followerData.Followers.isEmpty){
                followerData.refreshFollowers(size: 6, followersList: followerData.userInfo.followerUsers.map{$0.key})
            }
        }
        .fullScreenCover(item : $UserToFocus) { user in
            SearchSettingsView(userInfo: user)
        }
        .frame(width: UIScreen.main.bounds.width * 0.92)
        .navigationBarHidden(true)
        

    }
}

