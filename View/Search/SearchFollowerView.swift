//
//  SearchFollowingView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 8/9/22.
//

import SwiftUI

struct SearchFollowerView: View {
    
    @StateObject var followerData : FollowerViewModel
    @Environment(\.dismiss) var dismiss
    @State var hobbyFocused : HobbyModel
    @State var UserToFocus : UserModel?
    @State var toggle : Bool

    init(userInfo : UserModel, hobbyFocused: HobbyModel = HobbyModel.emptyHobby, toggle: Bool = false){
        _followerData = StateObject(wrappedValue: FollowerViewModel(userInfo: userInfo))
        _hobbyFocused = State(wrappedValue: hobbyFocused)
        _toggle = State(wrappedValue: toggle)
    }

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

                            Text(hobby.name)
                                .font(Font.custom("DM Sans", size: UIScreen.main.bounds.width * 0.026))
                                .fontWeight(.bold)
                                .foregroundColor(.black)

                        }

                    }

                }

            }
            
            if followerData.Followers.isEmpty{
                Text("no followers")
                    .font(Font.custom("DM Sans", size: 15))
            }else{
                ScrollView{

                    VStack(spacing: 0){

                        ForEach(followerData.Followers.map({$0.key}), id: \.self) { uid in
                            
                            let showFollower = (!toggle || followerData.FollowersHobbyIdDic[uid]!.contains(hobbyFocused.id)) && followerData.Followers[uid] != nil
                            
                            let user = followerData.Followers[uid] ?? UserModel.emptyUserModel
                            
                            Button {
                                self.UserToFocus = followerData.Followers[uid]
                            } label: {
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(Color(hex: 0xE4E7EC))
                                    .overlay(
                                        
                                        HStack(spacing:15){
                                              
                                            EquatableWebImage(url: user.imageurl, size: 30, shape: Circle())
                                                .equatable()
                                                .padding(5)

                                            VStack(alignment: .leading, spacing: 0){

                                                Text(user.username)
                                                    .font(Font.custom("DM Sans", size: 14))

                                                Text(user.real_name)
                                                    .font(Font.custom("DM Sans", size: 10))
                                                    .opacity(0.44)


                                            }
                                            .foregroundColor(.black)

                                            Spacer()
                                        }
                                        .padding(.horizontal)
                                        .frame(height: 50)
                                                        
                                        
                                    )
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.92, height: showFollower ? 50 : 0, alignment: .center)
                            .opacity(showFollower ? 1 : 0)
                            .padding(.vertical, showFollower ? 5 : 0)
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
        

    }
}
