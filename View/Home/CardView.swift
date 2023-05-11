//
//  CardView.swift
//  Testing
//
//  Created by Aria Askaryar on 4/13/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Foundation
let dateFormatter = DateFormatter()
struct CardView: View, Equatable {
    @StateObject var commentsData : CommentViewModel
    var postData : PostViewModel
    @State var clicked : Bool = false
    @State var showComment : Bool = false
    //@Binding var postToDelete : CardModel?
    var card: CardModel
    //@State var visiable: Bool = false
    @State var hobbyName : String!
    @Binding var hobbyToFocus : HobbyModel?
    @Binding var userToFocus : UserModel?
    @Binding var cardToFocus : CardModel?
    @Binding var videoToPlay : videoPlayInfo?
    @State var date : String = ""
//    var proxy: ScrollViewProxy?
//    var index : Int?
//
    
    init(postData: PostViewModel, card: CardModel, hobby: Binding<HobbyModel?>, userToFocus : Binding<UserModel?>, cardToFocus: Binding<CardModel?>, videoToPlay: Binding<videoPlayInfo?>){
        self.card = card
//        self.proxy = proxy
//        self.index = index
        _hobbyToFocus = hobby
        _commentsData = StateObject(wrappedValue: CommentViewModel(postId: card.id, postTime: card.timePosted))
        self.postData = postData
        _userToFocus = userToFocus
        _cardToFocus = cardToFocus
        _videoToPlay = videoToPlay
    }
    //var buttonHandler: (()->())? button handler mayer serve a purpose later on
    // init function for the cardview
    // Also if a buttonHandler would weant to be passed it would be in the manner of
    // buttonHandler: (()->())?
    var body: some View
    {
        VStack(alignment:.leading){
            
            //Text(card.id)
            
            HStack{
                
                HStack{
                    
                    EquatableWebImage(url: card.profileImage, size: 30, shape: Circle())
                        .equatable()

//                    VStack(alignment:.leading){
//
//                        Text(card.username)
//                            .font(Font.custom("DM Sans", size: 15))
//                            .foregroundColor(.black)
//
//                        Text("")
//                            .font(Font.custom("DM Sans", size: 10))
//                            .foregroundColor(.black)
//                            .fixedSize(horizontal: true, vertical: false)
//                    }
                    Text(card.username)
                        .font(Font.custom("DM Sans", size: 15))
                        .foregroundColor(.black)
                    
                }
                .onTapGesture {
                    
                    if card.uid != auth.currentUser?.uid ?? ""{
                        fetchUser(uid: card.uid) { userInfo in
                            if let userInfo = userInfo{
                                userToFocus = userInfo
                            }
                        }
                    }
                }
                
                Spacer()
                
//                Menu {
//                    Button("delete post", action: {
//                        postToDelete = card
//                    })
//
//                } label: {
//                    Image("list.bullet")
//                        .foregroundColor(.black)
//                }

                   //.padding(.trailing,5)
                
//                Text(card.hobby)
//                    .font(Font.custom("DM Sans", size: 15))
//                    .foregroundColor(.black)
//
//                HobbyPic(frame: 30, hobby: card.hobby, color: Constants.ShadeGray)

            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.08)
            .padding(.bottom, 5)
                //.frame(width: UIScreen.main.bounds.width * 0.84)
            
            //Text(card.image)
            
            ZStack{
                
                
                
                EquatableWebImage(url: card.image, size: UIScreen.main.bounds.width * 0.84, shape: RoundedRectangle(cornerRadius: 20))
                    .equatable()
                    .contentShape(RoundedRectangle(cornerRadius: 20))
                    .onTapGesture(){
                        cardToFocus = card
                    }
                    .overlay(
                        VStack{
                            HStack{
                                Button {
                                    videoToPlay = videoPlayInfo(uid: card.uid, pid: card.id)
                                } label: {
                                    
                                    Image(systemName: "play.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, alignment: .center)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .disabled(!card.isVideo)
                        .opacity(card.isVideo ? 1 : 0)
                    )
                
               
                
                VStack(alignment: .trailing){

                    HStack{

                        Spacer()

                        HStack(spacing: 13){

                            Text(hobbyName ?? "")
                                .font(Font.custom("DM Sans", size: 12))
                                .foregroundColor(.white)

                            HobbyPic(frame: 30, hobby: hobbyName ?? "", backgroundColor: Constants.ShadeGreen, foregroundColor: .white)

                        }
                        .padding()
                        .background(
                            VisualEffectView(effect: UIBlurEffect(style: .dark))
                                .frame(height: 40, alignment: .center)
                                .cornerRadius(10)
                                .opacity(0.7)
                        )
                        .onTapGesture(perform: {
                            fetchHobby(uid: card.uid, hid: card.hobby_id, refresh: false) { hobby in
                                if let hobby = hobby{
                                    self.hobbyToFocus = hobby
                                }else{
                                    print("error")
                                }
                            }
                        })
                        .padding(.trailing, 50)
                    }

                    Spacer()

                }
                    .padding(.top, 18)
                    .opacity(clicked ? 1 : 0)
                
//                Text(card.image)
//                    .onAppear{
//                        print(card.image)
//                    }
//                
            }
                    
            
            ZStack{
                VStack(alignment:.leading){
//                    HStack(spacing:5){
//                        WebImage(url: URL(string: card.profileImage)!)
//                                        .resizable()
//                                            .frame(width: 25, height:25)
//                                            .clipShape(Circle())
//                                            .aspectRatio(contentMode: .fit)
//                        Text(card.username.lowercased())
//                                            .fixedSize(horizontal: true, vertical: false)
//                                            .font(Font.custom("DM Sans", size: 15))
//                                            .foregroundColor(.black)
//                                        Text(card.timePosted)
//                                            .font(Font.custom("DM Sans", size: 10))
//                                            .foregroundColor(.black)
//                                            .fixedSize(horizontal: true, vertical: false)
//                                    }
//                    .padding(.trailing,160)
                    HStack{
                        
                        Text(card.description)
                            .font(Font.custom("DM Sans", size: 15))
                            .foregroundColor(.black)
                            .fixedSize(horizontal:false,vertical:true)
//                            .frame(minWidth: nil, idealWidth: nil, maxWidth: UIScreen.main.bounds.width-100, minHeight: nil, idealHeight: nil, maxHeight: 20, alignment: .leading)
//                            .padding([.bottom,.trailing], 50)
//                            .padding(.trailing,15)
                        
                        Spacer()
                        
                        Button(action: {
                            
//                            if let proxy = proxy, let index = index {
//                                withAnimation{
//                                    proxy.scrollTo(index, anchor: .top)
//                                    showComment.toggle()
//                                }
//                            }
                            withAnimation{
                                //proxy.scrollTo(index, anchor: .top)
                                showComment.toggle()
                            }
                            
                        }){
                            
                            Constants.ShadeTeal
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(
                                    
                                    Image(systemName: "ellipsis.bubble.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.white)
                                )
                        }//.padding(.trailing, 10)
                    }
                }
                //.padding(.leading,5)
//                Button(action: {})
//                {
//                Image("comments")
//                        .frame(width: 30, height:30)
//                        .clipShape(Circle())
//                        .aspectRatio(contentMode: .fit)
//                    .padding(.leading,300)
//                    //.padding(.bottom,30)
//                }
            }
            .padding(.top,5)
            .padding(.horizontal, UIScreen.main.bounds.width * 0.08)
            //.frame(width: UIScreen.main.bounds.width * 0.84)
       
        }
        .shadow(color: Color.black.opacity(0.2), radius:20, x:5, y:5)
        .padding(.bottom, 20)
        .fullScreenCover(isPresented: $showComment) {
            
            FullCommentView(commentData: commentsData)
        }
//        .alert(isPresented: $delete) {
//            Alert(title: Text("Confirm delete post"), message: nil, primaryButton: .destructive(Text("yes"), action: {
//                postData.deletePost(card: card)
//            }), secondaryButton: .cancel())
//        }
    }
    
    static func == (lhs: CardView, rhs: CardView) -> Bool {
        return lhs.card.id == rhs.card.id
    }
}
