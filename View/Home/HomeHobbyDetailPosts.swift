//
//  HomeHobbyDetailPosts.swift
//  ShadeInc
//
//  Created by Macbook on 7/24/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeHobbyDetailPosts: View {
    
    @StateObject var hobbyPostData : HobbyPostModel
//    @ObservedObject var postData : PostViewModel
//    @ObservedObject var newCommentData : NewCommentModel
    @Binding var  postOnFocus : CardModel?
    @State var scrollHeight = CGFloat(0)
    @State var contentHeight = CGFloat(0)
    @State var selectedCategories : [String] = [String]()
    var hobby : HobbyModel
    let length = UIScreen.main.bounds.width * 0.28
    let spacing = UIScreen.main.bounds.width * 0.02666
    
    init(hobby: HobbyModel, hobbyPostData: HobbyPostModel, postOnFocus: Binding<CardModel?>){
//        _postData = ObservedObject(wrappedValue: postData)
//        _newCommentData = ObservedObject(wrappedValue: newCommentData)
        _hobbyPostData = StateObject(wrappedValue: hobbyPostData)
        _postOnFocus = postOnFocus
        self.hobby = hobby
    }
    
    var body: some View {
        
        VStack{
            
            if let categories = hobby.categories{
                
                ScrollView(.horizontal,showsIndicators: false){
                    
                    HStack{
                        
                        ForEach(categories, id: \.self){ category in
                            
                            let selected : Bool = selectedCategories.contains(category)
                            
                            Button(action: {
                                
                                withAnimation{
                                    if selected{
                                        selectedCategories = selectedCategories.filter{$0 != category}
                                    }else{
                                        selectedCategories.append(category)
                                    }
                                }
                                
                            }) {
                                
                                Text(category)
                                    .foregroundColor(selected ? .white : .black)
                                    .font(Font.custom("DMSans-Regular", size: 14))
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                    .background(selected ? Constants.ShadeTeal : Constants.ShadeGray)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                    //.padding(.bottom, 5)
                }
            }
            
            
            
            let columns = [
                GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
                ]
            
            
            GeometryReader{ scrollProxy in
            
                ScrollView{
            
                    LazyVGrid(columns: columns, spacing: spacing) {
            
                        if let cards = hobbyPostData.hobbyPosts{
            
                            ForEach(cards) { card in
            
                                let ifContain :[String] = card.categories?.filter{selectedCategories.contains($0)} ?? [String]()
            
                                let border = !ifContain.isEmpty
            
                                
                                HobbyDetailPost(border: border, image: card.image)
                                    .onTapGesture {
                                        postOnFocus = card
                                    }
                                    .padding(.top, 5)
                                
                            }
                        }
            
            
            
                    }
                    .padding(.horizontal)
                    .background(
                        GeometryReader {
                            Color.clear.preference(key: ContentHeightKey.self,
                                                   value: $0.size.height)
                        }
                    )
            
                    if scrollHeight < contentHeight{
            
                        PullUpToRefresh(coordinateSpaceName: hobby.id, scrollHeight: scrollHeight){
                            
                            DispatchQueue.main.async {
                                hobbyPostData.getMorePosts(size: 9, hobbyId: hobby.id)
                            }
                            
                        }
                        .padding(.top)
                    }
                    //.frame(width: UIScreen.main.bounds.width * 0.894, alignment: .center)
            
                }
                .coordinateSpace(name: hobby.id)
                .padding(.top, 10)
                .onAppear(){
                    scrollHeight = scrollProxy.size.height
                    print("ScrollHeight: \(scrollHeight)")
                }
                .onPreferenceChange(ContentHeightKey.self) {
            
                    print ("contentHeight >> \($0)")
                    contentHeight = $0
            
                }
            }
            .padding(.top, 10)
            
            
            Spacer()
        }
    }
}

