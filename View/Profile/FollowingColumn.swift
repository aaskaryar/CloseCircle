//
//  FollowingBar.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 5/23/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct FollowingColumn: View {
    
    var operation : (String, UserModel) -> Void
    @ObservedObject var followingData : FollowingViewModel
    var uid : String
    
    
    var body: some View {
        
        if let user : UserModel = followingData.followingUserDic[uid]{
            RoundedRectangle(cornerRadius: 7)
                .fill(Color(hex: 0xE4E7EC))
                .frame(width: UIScreen.main.bounds.width * 0.92, height: 50, alignment: .center)
                .overlay(
                    
                    HStack{
                        
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

                        Spacer()

                        //var index = followingData.followingDic[user].count
                        //var index = 3
                        HStack(alignment: .center, spacing: -10){
                            
                            var zIndex = 2.0
                            
                            ForEach(followingData.followingHobbyNameDic[uid] ?? [""], id: \.self){ hobbyName in
                                
                                HobbyPic(frame: 30, hobby: hobbyName, backgroundColor: Constants.ShadeGreen, foregroundColor: .white)
                                    .zIndex(zIndex)
                                    .onAppear(){
                                        zIndex -= 1
                                    }

                            }
                            
                        }
                        .padding(.trailing, 5)
    //                    if(followingData.followingHobbyNameDic[uid] != nil){
    //                        let hobby = followingData.followingHobbyNameDic[uid]![0]
    //
    //                        Button(action:{operation(hobby, user)}){
    //                            Text("unfollow \(hobby)")
    //                        }
    //
    //                    }
                        
                        
                        Menu {
                            
                            ForEach(followingData.followingHobbyNameDic[uid] ?? [""], id: \.self){ hobby in
                                Button("unfollow " + hobby, action: {
                                    
                                    operation(hobby, user)
    //                                let hobbyId = followingData.hobbyMap.keysForValue(value: hobby)[0]
    //                                followingData.unfollowHobby(uid: user.uid, HobbyId: hobbyId)
                                })
                            }
                            
                        } label: {
                            Text("unfollow")
                                .font(Font.custom("DM Sans", size: 15))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(
                                    Color.white
                                        .cornerRadius(4)
                                )
                                                                            
                        }//.padding(.trailing)

    //                                        Button(action: {
    //
    //
    //                                            DeleteAlert(person: !toggle, user: user)
    //
    //                                        }){
    //
    //                                            Text("unfollow")
    //                                                .font(Font.custom("DM Sans", size: 15))
    //                                                .fontWeight(.bold)
    //                                                .foregroundColor(.black)
    //                                                .background(
    //                                                    Color.white
    //                                                        .cornerRadius(4)
    //                                                        .frame(width: 80, height: 30)
    //                                                )
    //
    //                                        }
                    }
                    .padding(.horizontal, 10)
                    .frame(height: 50)
                                    
                    
                )
        }else{
            EmptyView()
        }
        
        
        
        
    }
    
}
