//
//  FollowerColumn.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 5/25/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct FollowerColumn: View {
    
    //var operation : (String, String) -> Void
    @ObservedObject var followerData : FollowerViewModel
    var uid : String
    var hobby : HobbyModel
    
    var body: some View {
        
        if let user =  followerData.Followers[uid]{
            
            RoundedRectangle(cornerRadius: 7)
                .fill(Color(hex: 0xE4E7EC))
                .frame(width: UIScreen.main.bounds.width * 0.92, height: 50, alignment: .center)
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

                        Spacer()
                        
                        if(hobby != HobbyModel.emptyHobby){
                            Button(action: {
                                followerData.forceUnfollow(uid: uid, hobbyId: hobby.id)
                            }){
                                Text("remove")
                                    .font(Font.custom("DM Sans", size: 15))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(
                                        Color.white
                                            .cornerRadius(4)
                                    )
                                                                                
                            }
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 50)
                                    
                    
                )
        }else{
            EmptyView()
        }
        
    }
}
