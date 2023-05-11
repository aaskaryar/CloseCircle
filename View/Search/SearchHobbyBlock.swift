//
//  SearchHobbyBlock.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/30/22.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI


struct SearchHobbyBlock: View {
    
    @State var hobby : HobbyModel
    @State var following = false
    @State var pending = false
    @State var alertInfo : followingBlockAlertInfo?
    @State var attempts: Int = 0
    
    @ObservedObject var searchUserData : SearchUserModel
    
    @EnvironmentObject var followingData : FollowingViewModel
    @EnvironmentObject var  viewModel : RegistrationViewModel
    @EnvironmentObject var requestData : RequestViewModel
    
    let length : CGFloat = UIScreen.main.bounds.width * 0.826 / 2
    
    var body: some View {
        
        VStack(spacing: 15){
            
            EquatableWebImage(url: hobby.url, size: length, shape: RoundedRectangle(cornerRadius: 15))
                .equatable()
                .onTapGesture {
                    searchUserData.detail = false
                    if hobby.privacy == Constants.Public || (following && !pending){
                        searchUserData.hobbyOnFocus = hobby
                        searchUserData.detail = true
                    }else{
                        withAnimation(.default) {
                            self.attempts += 1
                        }
                    }
                }
                .overlay(
                    
                    VStack{
                        
                        HStack{
                            
                            Spacer()
                            
                            Button(action: {
                                
                                if !following && !pending{
                                    
                                    let request = requestData.followHobby(hobby: hobby, userInfo: viewModel.userInfo)
                                    
                                    withAnimation {
                                        following.toggle()
                                    }
                                    
                                    if request{
                                        if hobby.pendingFollowers == nil{
                                            hobby.pendingFollowers = [auth.currentUser!.uid]
                                        }else{
                                            hobby.pendingFollowers!.append(auth.currentUser!.uid)
                                        }
                                        pending = true
                                    }
                                    
//                                    alertInfo = followingBlockAlertInfo(unfollow: false, title: request ? "Request Sent" : "Follow Successfully", message: request ? "You will be follwing this hobby after the user allow you" : "You can go look at the post now!!")
                                    
                                }else if !pending{
                                    
                                    alertInfo = followingBlockAlertInfo(unfollow: true, title: "Confirm unfollowing \(hobby.name)", message: "")
                                }
                                
                            }) {
                                if !following && !pending{
                                    Text("Follow")
                                       .foregroundColor(.white)
                                       .font(Font.custom("DM Sans", size: 14))
                                       .fontWeight(.bold)
                                       .lineLimit(1)
                                       .padding(.horizontal, 10)
                                       .padding(.vertical, 5)
                                       .background(
                                         Constants.ShadeGreen
                                            .frame(height: 26, alignment: .center)
                                            .cornerRadius(9)
                                       )
                                }else{
                                    Text(pending ? "Requesting" : "Following")
                                       .foregroundColor(.black)
                                       .font(Font.custom("DM Sans", size: 14))
                                       .fontWeight(.bold)
                                       .lineLimit(1)
                                       .padding(.horizontal, 10)
                                       .padding(.vertical, 5)
                                       .background(
                                         Constants.ShadeGray
                                            .frame(height: 26, alignment: .center)
                                            .cornerRadius(9)
                                       )
                                }
                                
                             }
                             .padding(10)
                             //.padding(.leading, 15)
                            
//                            Spacer()
                            
                        }
                        
                        Spacer()
                        
                        ZStack{
                            
                            VisualEffectView(effect: UIBlurEffect(style: .dark))
                                .frame(width: length, height: 42, alignment: .bottom)
                                .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                                .opacity(0.7)
                            
                            HStack{
                                
                                
                                Spacer()
                                
                                if(Constants.names.contains(hobby.name.lowercased())){
                                    Image(hobby.name.lowercased())
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 20, height: 20)
                                }else{
                                    Text(hobby.name.prefix(1).uppercased())
                                        .font(Font.custom("DM Sans", size: 10))
                                        .fontWeight(.bold)
                                        .frame(width: 20, height: 20)
                                        .background(
                                            Color(hex: 0xE4E7EC)
                                                .frame(width: 20, height: 20, alignment: .center)
                                                .clipShape(Circle())
                                        )
                                }
                                
                                Text(hobby.name)
                                    .font(Font.custom("DM Sans", size: 15))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                            }
                                
                        }
                            
                    }
                    
                )
                .overlay(
                    HStack{
                        
                        VStack{
                            
                            if(hobby.privacy != Constants.Public && (!following || pending)){
                                
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                    .padding(8)
                                    .background(Color(hex: 0xE4E7EC))
                                    .foregroundColor(.black)
                                    .clipShape(Circle())
                                
                            }
                            
                            
                            Spacer(minLength: length)
                        }
                        
                        Spacer(minLength: length)
                    }
                )
        }
        .padding()
        .onAppear(){
            if let followers = hobby.followers{
                following = followers.contains(auth.currentUser!.uid)
            }else{
                following = false
            }
            
            if let pendings = hobby.pendingFollowers{
                pending = pendings.contains(auth.currentUser!.uid)
            }else{
                pending = false
            }
            //following = (hobby.followers == nil) ? false : hobby.followers!.contains(auth.currentUser!.uid)
        }
        .alert(item: $alertInfo) { info in
            if !info.unfollow{
                return Alert(title: Text(info.title), message: Text(info.message), dismissButton: .cancel(Text("Ok")))
            }else{
                return Alert(title: Text(info.title), message: nil, primaryButton: .destructive(Text("Confirm"), action: {
                    withAnimation {
                        following.toggle()
                    }
                    followingData.unfollowHobby(uid: hobby.uid, HobbyId: hobby.id)
                }), secondaryButton: .cancel())
            }
        }
    }
}

struct followingBlockAlertInfo : Identifiable{
    var id = UUID()
    var unfollow : Bool
    var title : String
    var message : String
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 5
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}
