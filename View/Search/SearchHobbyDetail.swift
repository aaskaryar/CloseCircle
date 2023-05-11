//
//  SearchHobbyDetail.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/19/22.
//

import SwiftUI
import SDWebImageSwiftUI
import SDWebImage

struct SearchHobbyDetail: View {
    
    @Environment(\.dismiss) var dismiss
    @State var selectedCategories : [String] = [String]()
    @State var postOnFocus : CardModel?
    @State var scrollHeight = CGFloat.zero
    @State var contentHeight = CGFloat.zero
    @State var showFollowers : Bool = false
    @State var userInfo : UserModel
    @State var hobby : HobbyModel
    
    let length = UIScreen.main.bounds.width * 0.28
    let spacing = UIScreen.main.bounds.width * 0.02666
    
    var body: some View {
        
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
                
                Button {
                    showFollowers.toggle()
                } label: {
                    Text(String(hobby.followers?.count ?? 0) + ( hobby.followers?.count == 1 ? " Follower" : " Followers"))
                        .font(Font.custom("DM Sans", size: 14))
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Color(hex: 0xE4E7EC)
                                .cornerRadius(9)
                        )
                        .padding(.trailing, 5)
                        .foregroundColor(.black)
                }

                
                
                
                Button(action: {}){
                    
                    Text(hobby.privacy)
                        .font(Font.custom("DM Sans", size: 14))
                        .fontWeight(.bold)
                        .frame(width: 71, height: 30, alignment: .center)
                        .cornerRadius(9)
                        .foregroundColor(.white)
                        .background(
                            Constants.ShadeGreen
                                .cornerRadius(9)
                        )
                        
                    
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            
            HobbyPostGrid(userInfo: userInfo, hobby: hobby, postOnFocus: $postOnFocus)
            
            
        }
        .fullScreenCover(item: $postOnFocus) { card in
            SearchPostDetail(card: card)
        }
        .frame(width: UIScreen.main.bounds.width - 20)
        .fullScreenCover(isPresented: $showFollowers) {
            SearchFollowerView(userInfo: userInfo, hobbyFocused: hobby, toggle: true)
        }
    }
}

//struct SearchHobbyDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchHobbyDetail()
//    }
//}
