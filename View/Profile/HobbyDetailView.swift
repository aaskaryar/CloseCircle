//
//  HobbyDetailView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/27/22.
//

import SwiftUI
import ImageIO
import SDWebImageSwiftUI

struct HobbyDetailView: View {
    
    let length = UIScreen.main.bounds.width * 0.28
    
    
    @State var postOnFocus : CardModel?
    @State var spacer : HobbyModel? = nil
    //@State var hobby : HobbyModel
    @EnvironmentObject var postData : PostViewModel
    @EnvironmentObject var hobbyData : HobbiesViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        let hobby = hobbyData.hobbyOnDetail
        
        let isInviteOnly = hobby.privacy == Constants.Own
        
        NavigationView{
            
            VStack{
                
                EquatableWebImage(url: hobby.url, size: UIScreen.main.bounds.width * 0.312, shape: RoundedRectangle(cornerRadius: 20))
                    .padding()
                
                Text(hobby.name)
                    .font(Font.custom("DMSans-Bold", size: 16))
                
                Divider()
                    .shadow(radius: 5)
                    .padding()
                
                HStack{
                    
                    Button(action: {
                        withAnimation(.easeInOut){
                            dismiss()
                        }
                    }) {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                            .padding(.trailing, 5)
                    }
                    
    //                Text(hobbyData.hobbyOnDetail.name)
    //                    .font(Font.custom("DM Sans", size: 20))
    //                    .fontWeight(.bold)
                    
                    Spacer()
                    
                    NavigationLink {
                        FollowerView(hobbyFocused: hobby, toggle: true, only1Hobby: true)
                    } label: {
                        Text(String(hobby.followers?.count ?? 0) + ( hobby.followers?.count == 1 ? " Follower" : " Followers"))
                            .font(Font.custom("DM Sans", size: 14))
                            .fontWeight(.bold)
                            .frame(width: 106, height: 30, alignment: .center)
                            .background(
                                Color(hex: 0xE4E7EC)
                                    .cornerRadius(9)
                            )
                            .padding(.trailing, 5)
                            .foregroundColor(.black)
                    }
                    
                    Menu{
                        
                        Button(Constants.Private, action: {
                            hobbyData.updateHobbyPrivacy(privacy: Constants.Private)
                            withAnimation {
                                hobbyData.hobbyOnDetail.privacy = Constants.Private
                            }
                            
                        })
                            .disabled(hobbyData.hobbyOnDetail.privacy == Constants.Private)
                        
                        Button(Constants.Public, action: {
                            hobbyData.updateHobbyPrivacy(privacy: Constants.Public)
                            withAnimation {
                                hobbyData.hobbyOnDetail.privacy = Constants.Public
                            }
                        })
                            .disabled(hobbyData.hobbyOnDetail.privacy == Constants.Public)
                        
                        Button(Constants.Own, action: {
                            hobbyData.updateHobbyPrivacy(privacy: Constants.Own)
                            withAnimation {
                                hobbyData.hobbyOnDetail.privacy = Constants.Own
                            }
                        })
                            .disabled(hobbyData.hobbyOnDetail.privacy == Constants.Own)
                        
                    } label: {
                        
                        Text(hobby.privacy)
                            .font(Font.custom("DM Sans", size: 14))
                            .fontWeight(.bold)
                            .modifier(FitButtonModifier(cornerRadius: 9, backgroundColor: Constants.ShadeGreen, foregroundColor: .white))
                    }
                    .padding(.trailing, isInviteOnly ? 5 : 0)
                    
                    if isInviteOnly{
                        
                        NavigationLink(destination: InvitePeople(hobby: hobby).navigationBarHidden(true)){
                            
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundColor(Color.white)
                                .aspectRatio(contentMode: .fit)
                                .background(Constants.ShadeTeal.frame(width: 20, height: 20) .clipShape(Circle()))
                        }
                    }
                    
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                HobbyPostGrid(userInfo: postData.user , hobby: hobby, postOnFocus: $postOnFocus)
                Spacer()
            }
            .fullScreenCover(item: $postOnFocus) { card in
                PostDetailView(card: card, hobbyToFocus: $spacer)
            }
            .navigationBarHidden(true)
        }
        
        
//        .onAppear {
//            searchUserData.fetchPostsForHobby(hobbyId: hobby.id)
//        }
    }
}
