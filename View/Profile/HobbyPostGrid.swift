//
//  HobbyPostGrid.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 8/11/22.
//

import SwiftUI

struct HobbyPostGrid: View {
    
    @StateObject var hobbyPostData : HobbyPostModel
    @Binding var postOnFocus : CardModel?
    @State var selectedCategories : [String] = [String]()
    @State var scrollHeight = CGFloat(0)
    @State var contentHeight = CGFloat(0)
    var categories : [String]
    var hobby : HobbyModel
    let spacing = UIScreen.main.bounds.width * 0.02666

    
    init(userInfo: UserModel, hobby: HobbyModel, postOnFocus: Binding<CardModel?>){
        _hobbyPostData = StateObject(wrappedValue: HobbyPostModel(userInfo: userInfo, hobby: hobby))
        _postOnFocus = postOnFocus
        categories = hobby.categories ?? [String]()
        self.hobby = hobby
    }
    
    var body: some View {
        
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
        
                            if border || selectedCategories.isEmpty{
                                
                                EquatableWebImage(url: card.image, size: border || selectedCategories.isEmpty ? UIScreen.main.bounds.width * 0.28 : 0, shape: RoundedRectangle(cornerRadius: 12))
                                    .equatable()
                                    .onTapGesture {
                                        postOnFocus = card
                                    }
                                    .overlay(
                                        Image(systemName: "play.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, alignment: .center)
                                            .foregroundColor(.white)
                                            .opacity(card.isVideo ? 1 : 0)
                                    )
                                    .padding(.top, 5)
                            }else{
                                EmptyView()
                            }
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
        
                        hobbyPostData.getMorePosts(size: 9, hobbyId: hobby.id)
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
    }
}

//struct HobbyPostGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        HobbyPostGrid()
//    }
//}
