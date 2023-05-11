//
//  NotificationView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/29/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct NotificationView: View {
    
    
    @ObservedObject var notificationData : NotificationViewModel
    @ObservedObject var newPostData : NewPostModel
    @ObservedObject var hobbyData : HobbiesViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var scrollHeight = CGFloat.zero
    @State var contentHeight = CGFloat.zero
    @State var forwardPostId : ForwardPostRequest = ForwardPostRequest(postId: nil)
    @State var isLoading = false
    @State var alertInfo : AlertInfo?
    @State var forwardCard : CardModel?
    
    @EnvironmentObject var requestData : RequestViewModel
    @EnvironmentObject var inviteData : InviteViewModel
    
    var body: some View {
        
        ZStack{
            
            VStack{
                
                HStack{
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding(.trailing, 5)
                            .foregroundColor(.black)
                    }
                    
                    Text("Notifications")
                        .font(Font.custom("DM Sans", size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                }
                .padding(.vertical)
                
                GeometryReader{ scrollProxy in
                    
                    ScrollView{
                        
                        VStack{
                            
                            HStack{
                                
                                Text("Follower Requests")
                                    .font(Font.custom("DM Sans", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .opacity(0.7)
                                
                                Spacer()
                                
                                Text(String(requestData.requestsCount))
                                    .font(Font.custom("DM Sans", size: 8))
                                    .foregroundColor(.white)
                                    .opacity(requestData.requestsCount == 0 ? 0 : 1)
                                    .background(
                                        Color(hex: 0xFF4D44)
                                            .frame(width: 17, height: 17, alignment: .center)
                                            .clipShape(Circle())
                                            .opacity(requestData.requestsCount == 0 ? 0 : 1)
                                    )
                                    .padding(.trailing)
                            }
                            .frame(width: UIScreen.main.bounds.width - 40)
                            
                            if(requestData.requests.count == 0){
                                
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(Color(hex: 0xE4E7EC))
                                    .frame(width: UIScreen.main.bounds.width-30, height: 50, alignment: .center)
                                    .overlay(
                                        
                                        Text("No Coming Requests")
                                        
                                    )
                            }else{
                                
                                ForEach(requestData.requests) { request in
                                    
                                    RequestView(request: request)
                                    
                                }
                                
                            }
                            
                            HStack{
                                
                                Text("My Requests")
                                    .font(Font.custom("DM Sans", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .opacity(0.7)
                                
                                Spacer()
                                
                                Text(String(requestData.requestsCount))
                                    .font(Font.custom("DM Sans", size: 8))
                                    .foregroundColor(.white)
                                    .opacity(requestData.requestsCount == 0 ? 0 : 1)
                                    .background(
                                        Color(hex: 0xFF4D44)
                                            .frame(width: 17, height: 17, alignment: .center)
                                            .clipShape(Circle())
                                            .opacity(requestData.requestsCount == 0 ? 0 : 1)
                                    )
                                    .padding(.trailing)
                            }
                            .frame(width: UIScreen.main.bounds.width - 40)
                            
                            if(requestData.myPendingRequests.count == 0){
                                
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(Color(hex: 0xE4E7EC))
                                    .frame(width: UIScreen.main.bounds.width-30, height: 50, alignment: .center)
                                    .overlay(
                                        
                                        Text("No Requests")
                                        
                                    )
                            }else{
                                
                                ForEach(requestData.myPendingRequests) { request in
                                    
                                    RequestView(request: request)
                                    
                                }
                                
                            }
                            
                            HStack{
                                
                                Text("My Invites")
                                    .font(Font.custom("DM Sans", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .opacity(0.7)
                                
                                Spacer()
                            }
                            .frame(width: UIScreen.main.bounds.width - 40)
                            
                            if(inviteData.invites.count == 0){
                                
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(Color(hex: 0xE4E7EC))
                                    .frame(width: UIScreen.main.bounds.width-30, height: 50, alignment: .center)
                                    .overlay(
                                        
                                        Text("No Invites")
                                        
                                    )
                            }else{
                                
                                ForEach(inviteData.invites) { invite in
                                    
                                    InviteView(invite: invite)
                                    
                                }
                                
                            }
                            
                            HStack{
                                
                                Text("Invites to Me")
                                    .font(Font.custom("DM Sans", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .opacity(0.7)
                                
                                Spacer()
                            }
                            .frame(width: UIScreen.main.bounds.width - 40)
                            
                            if(inviteData.myPendingInvitess.count == 0){
                                
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(Color(hex: 0xE4E7EC))
                                    .frame(width: UIScreen.main.bounds.width-30, height: 50, alignment: .center)
                                    .overlay(
                                        
                                        Text("No Invites to Me")
                                        
                                    )
                            }else{
                                
                                ForEach(inviteData.myPendingInvitess) { invite in
                                    
                                    InviteView(invite: invite)
                                    
                                }
                                
                            }
                        }
                        
                        
                        
                        
                        HStack{
                            
                            Text("Activity")
                                .font(Font.custom("DM Sans", size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .opacity(0.7)
                            
                            Spacer()
                            
                        }
                        
                        EmptyView()
                            .frame(height: 5)
                        
                        ForEach(notificationData.Notifications, id:\.self){ notification in
                            
                            ActivityView(notification: notification, forwardPostId: $forwardPostId)
                            
                        }
                        .background(
                            GeometryReader {
                                Color.clear.preference(key: NotificationContentHeightKey.self, value: $0.size.height)
                            }
                        )
                        
                        if scrollHeight < contentHeight{
                            
                            PullUpToRefresh(coordinateSpaceName: "activity", scrollHeight: scrollHeight){
                                notificationData.getOldNotifications(size: 10)
                            }
                        }
                    }
                    .coordinateSpace(name: "activity")
                    .onAppear(){
                        scrollHeight = scrollProxy.size.height
                        print ("scrollHeight: \(scrollHeight)")
                    }
                    .onPreferenceChange(NotificationContentHeightKey.self){
                        contentHeight = $0
                        print ("contentHeight: \(contentHeight)")
                    }
                }
                
                
                Spacer()
                
            }
            .padding(.horizontal)
            .navigationBarHidden(true)
            
            VStack{
                
                Spacer()
                
                ProgressView()
                    .padding()
                    .background(
                        .regularMaterial,
                        in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                
                Spacer()
            }
            .opacity(isLoading ? 1 : 0)
        }
        .onChange(of: forwardPostId, perform: { forwardRequest in
            print (forwardRequest)
            if let postId = forwardRequest.postId{
                isLoading = true
                fetchPost(postId: postId) { card in
                    guard let card = card else{
                        isLoading = false
                        alertInfo = AlertInfo(Title: "Cannot Find Post", Message: "It might be deleted")
                        return
                    }
                    forwardCard = card
                }
            }else{
                alertInfo = AlertInfo(Title: "Unexpected Error", Message: "Please try again")
            }
        })
        .alert(item: $alertInfo) { alertinfo in
            Alert(title: Text(alertinfo.Title), message: Text(alertinfo.Message), dismissButton: .cancel())
        }
        .fullScreenCover(item: $forwardCard) { card in
            ForwardPostView(newPostData: newPostData, hobbyData: hobbyData, card: card, isLoading: $isLoading)
        }
    }
}

struct NotificationContentHeightKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct ForwardPostRequest : Identifiable, Equatable{
    var id = UUID()
    var postId : String?
}

struct AlertInfo : Identifiable{
    var id = UUID()
    var Title : String = ""
    var Message : String = ""
}
