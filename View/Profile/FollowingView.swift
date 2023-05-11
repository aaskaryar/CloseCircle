//
//  FollowingView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 5/22/22.
//

import SwiftUI
import SDWebImageSwiftUI
import UIKit

struct FollowingView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var followingData : FollowingViewModel
    @State var hobbyFocused : String
    @State var toggle = false
    @State var scrollHeight = CGFloat.zero
    @State var contentHeight = CGFloat.zero
    @State var UserToFocus : UserModel?
//    @State var alertDetails: unfollowAlertDetail?
//    @State var previousDetails : unfollowAlertDetail?
    
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
                                    
                                    FollowingColumn(operation: DeleteAlert(hobbyName:user:),followingData: followingData, uid: uid)
                                        .foregroundColor(.black)
                                    
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
//
    func DeleteAlert(hobbyName: String, user: UserModel) {
//        print("allerted")
//        alertDetails = unfollowAlertDetail(hobbyName: hobbyName, user: user)
        let hobbyId = followingData.hobbyMap.keysForValue(value: hobbyName)[0]
        followingData.unfollowHobby(uid: user.uid, HobbyId: hobbyId)
    }
//

}


extension Dictionary where Value: Equatable {
    /// Returns all keys mapped to the specified value.
    /// “`
    /// let dict = ["A": 1, "B": 2, "C": 3]
    /// let keys = dict.keysForValue(2)
    /// assert(keys == ["B"])
    /// assert(dict["B"] == 2)
    /// “`
    func keysForValue(value: Value) -> [Key] {
        return compactMap { (key: Key, val: Value) -> Key? in
            value == val ? key : nil
        }
    }
}
