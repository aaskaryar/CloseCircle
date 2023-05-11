//
//  SearchFollowerView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 8/9/22.
//

import SwiftUI

struct SearchFollowingView: View {
    
    @StateObject var followingData : FollowingViewModel
    @State var hobbyFocused : String  = ""
    @State var toggle = false
    @State var scrollHeight = CGFloat.zero
    @State var contentHeight = CGFloat.zero
    @State var UserToFocus : UserModel?
    @Environment(\.dismiss) var dismiss
    
    
    init(userInfo: UserModel){
        _followingData = StateObject(wrappedValue: FollowingViewModel(userInfo: userInfo))
    }
    
    var body: some View {
        
        VStack{
            
            HStack(alignment: .top){

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

                Text("Followings")
                    .font(Font.custom("DM Sans", size: 29))
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Spacer()

            }
            .padding(.vertical, 20)
            
            
            ScrollView(.horizontal,showsIndicators: false){
                
                HStack{
                    
                    //Text( String(followingData.hobbySet.map({$0.key}).count) )
                    
                    ForEach(followingData.hobbySet.map({$0.key}), id: \.self) {hobby in
                        
                        VStack(spacing: UIScreen.main.bounds.width * 0.026){
                                                    
                            Button(action:{
                                if(!toggle){
                                    toggle.toggle()
                                    hobbyFocused = hobby
                                    // if untoggled, toggle this hobby
                                }else{
                                    // if already toggled, change hobbyfocuesd if different
                                    if(hobby != hobbyFocused){
                                        //print("Change")
                                        hobbyFocused = hobby
                                    }else{
                                        toggle.toggle()
                                        hobbyFocused = ""
                                        //print("toggle")
                                    }
                                }
                                
                            }){
                                
                                HobbyPic(frame: UIScreen.main.bounds.width * 0.13, hobby: hobby, backgroundColor: (hobby == hobbyFocused) ? Constants.ShadeGreen : Constants.ShadeGray, foregroundColor: (hobby == hobbyFocused) ? .white : .black)
                            }

                            Text(hobby)
                                .font(Font.custom("DM Sans", size: UIScreen.main.bounds.width * 0.026))
                                .fontWeight(.bold)
                                .foregroundColor(.black)

                        }
                        
                    }
                    
                }
                
            }
            
            if(followingData.hobbySet.map({$0.key}).count == 0){
                Text("Go follow some people")
            }
            
            GeometryReader{ scrollProxy in
                
                ScrollView{
                    
                    PullToRefresh(coordinateSpaceName: "Following"){
                        followingData.getMoreFollowings(size: 10)
                    }
                    
                    VStack{
                        
                        ForEach(followingData.followingUids, id: \.self) { uid in
                            
                            Button {
                                self.UserToFocus = followingData.followingUserDic[uid]
                            } label: {
                            
                                if(!toggle || (followingData.followingHobbyNameDic[uid] != nil && followingData.followingHobbyNameDic[uid]!.contains(hobbyFocused))){
                                    
                                    if let user : UserModel = followingData.followingUserDic[uid]{
                                        RoundedRectangle(cornerRadius: 7)
                                            .fill(Color(hex: 0xE4E7EC))
                                            .frame(width: UIScreen.main.bounds.width * 0.92, height: 50, alignment: .center)
                                            .foregroundColor(.black)
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
                                                    .foregroundColor(.black)

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
                                                }
                                                .padding(.horizontal, 10)
                                                .frame(height: 50)
                                                                
                                                
                                            )
                                    }else{
                                        EmptyView()
                                    }
                                    
                                }else{
                                    EmptyView()
                                }
                            }
                            
                        }
                        
                    }
                    .background(
                        GeometryReader {
                            Color.clear.preference(key: ContentHeightKey.self,
                                                   value: $0.size.height)
                        }
                    )
                    
                    if scrollHeight < contentHeight{
                        
                        PullUpToRefresh(coordinateSpaceName: "Following", scrollHeight: scrollHeight){
                            followingData.getMoreFollowings(size: 10)
                        }
                    }
                    
                }
                .coordinateSpace(name: "Following")
                .onAppear(){
                    scrollHeight = scrollProxy.size.height
                    print("ScrollHeight: \(scrollHeight)")
                }
                .onPreferenceChange(ContentHeightKey.self) {
                    
                    print ("contentHeight >> \($0)")
                    contentHeight = $0
                    
                }
            }
            Spacer()
            
        }
        .fullScreenCover(item : $UserToFocus) { user in
            SearchSettingsView(userInfo: user)
        }
        .frame(width: UIScreen.main.bounds.width * 0.92)
    }
}



//struct SearchFollowerView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchFollowerView()
//    }
//}
