//
//  ForwardPostView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 6/28/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ForwardPostView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var newPostData : NewPostModel
    @ObservedObject var hobbyData : HobbiesViewModel
    @State private var caption: String = ""
    @State private var selectedCategories : [String] = [String]()
    
    var card : CardModel
    @Binding var isLoading : Bool
    
    var length = UIScreen.main.bounds.width
    
    var body: some View {
        
        NavigationView{
            
            ScrollView(showsIndicators: false){
                
                VStack(alignment:.leading){
                    
                    HStack{
                        
                        Text("add post to profile")
                            .font(Font.custom("DMSans-Bold", size: length * 0.064))
                        
                        Spacer()
                        
                        Button(action: {
                            isLoading = false
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: length * 0.064, height: length * 0.064)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.vertical)
                    
                    EquatableWebImage(url: card.image, size: length, shape: RoundedRectangle(cornerRadius: 15))
                        .equatable()
                        .overlay(
                            
                            VStack{
                                
                                Spacer()
                                
                                ZStack{
                                    
                                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                                        .frame(width: UIScreen.main.bounds.width-40, height: 42, alignment: .bottom)
                                        .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                                        .opacity(0.7)
                                    
                                    HStack{
                                        
                                        Spacer()
                                        
                                        HobbyPic(frame: 27, hobby: card.hobby, backgroundColor: .white, foregroundColor: .black)
                                        
                                        Text(card.hobby)
                                            .font(Font.custom("DM Sans", size: 13))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                    }
                                        
                                }
                                    
                            }
                        )
                        .padding(.bottom)
                    
                    Group{
                        Text("tagged by")
                            .font(Font.custom("DMSans-Bold", size: length * 0.0426))
                            .padding(.bottom, 5)
                        
                        Text("@\(card.username)")
                            .foregroundColor(.white)
                            .font(Font.custom("DMSans-Bold", size: length * 0.0266))
                            .lineLimit(1)
                            .padding(.all, 5)
                            .background(
                                Constants.ShadeTeal
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                        //.padding(.bottom)
                    
                    Text("selected a hobby")
                        .font(Font.custom("DMSans-Bold", size: length * 0.0426))
                        .padding(.vertical, 8)
                    
                    HStack{
                        
                        ScrollView(.horizontal,showsIndicators: false){
                            
                            HStack{
                                
                                if(hobbyData.hobbies.count != 0){
                                    
                                    ForEach(hobbyData.hobbies) { hobby in
                                        
                                        VStack{
                                            
                                            Button(action:{
                                                if hobbyData.selectedHobby != hobby{
                                                    selectedCategories.removeAll()
                                                }
                                                hobbyData.selectedHobby = hobby
                                            }){
                                                
                                                let onFocus = hobbyData.selectedHobby.name == hobby.name
                                                
                                                HobbyPic(frame: length * 0.1333, hobby: hobby.name, backgroundColor: onFocus ? Constants.ShadeGreen : Constants.ShadeGray, foregroundColor: onFocus ? .white : .black)
                                            }
                                            
                                            Text(hobby.name)
                                                .foregroundColor(.black)
                                                .font(Font.custom("DMSans-Bold", size: 12))
                                        }
                                    }
                                    //.padding(.trailing,-5)
                                }
                                
                                VStack{
                                    NavigationLink(destination:NewHobby().navigationBarHidden(true)){
                                        
                                        ZStack{
                                            Constants.ShadeTeal
                                                .frame(width: length * 0.077, height: length * 0.077)
                                                .clipShape(Circle())
                                            Image(systemName: "plus")
                                                .resizable()
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(Color.white)
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        .padding(.bottom, 21)
                                    }
                                }
                            }
                            .disabled(newPostData.isPosting ? true : false )
                            //.padding(.leading,10)
                           // .padding(.leading,)
                            //.padding(.trailing,20)
                        }
                    }
                    //.padding(.vertical)
                    
                    HStack{
                        
                        Text("add tags to post")
                            .foregroundColor(.black)
                            .font(Font.custom("DMSans-Bold", size: length * 0.0426))
                        
                        VStack{
                            
                            NavigationLink(destination:NewCategoryView(hobbyData: hobbyData, hobby: hobbyData.selectedHobby, operation: hobbyData.addCategories(id: tag:)).navigationBarHidden(true)){
                                
                                ZStack
                                {
                                    Constants.ShadeTeal
                                        .frame(width: length * 0.077, height: length * 0.077)
                                        .clipShape(Circle())
                                    
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(Color.white)
                                        .aspectRatio(contentMode: .fit)
                                    
                                }
                            }
                            .disabled(hobbyData.selectedHobby.id == "")
                        }
                    }
                    .padding(.top, 8)
                    
                    HStack{
                        
                        ScrollView(.horizontal,showsIndicators: false){
                            
                            HStack{
                                
                                var categories = hobbyData.selectedHobby.categories ?? [String]()
                                
                                ForEach(categories, id: \.self){ category in
                                    
                                    Button(action: {
                                        
                                        if(selectedCategories.contains(category)){
                                            selectedCategories = selectedCategories.filter(){$0 != category}
                                        }else{
                                            selectedCategories.append(category)
                                        }
                                        //print(categories)
                                        
                                    }){
                                        
                                        Text(category)
                                            .foregroundColor(selectedCategories.contains(category) ? .white : .black)
                                            .font(Font.custom("DMSans-Bold", size: 14))
                                            .padding(.all, 10)
                                            .background(
                                                
                                                Group{
                                                    
                                                    if(selectedCategories.contains(category)){
                                                        Constants.ShadeGreen
                                                    }else{
                                                        Constants.ShadeGray
                                                    }
                                                }
                                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                            )
                                    }
                                }
                            }
                            .disabled(newPostData.isPosting ? true : false )
                            .opacity(newPostData.isPosting ? 0.5 : 1)
                            //.padding(.leading,10)
                           // .padding(.leading,)
                            //.padding(.trailing,20)
                        }
                    }
                    .padding(.vertical, 5)
                    
                    Group{
                        Text("caption")
                            .foregroundColor(.black)
                            .font(Font.custom("DMSans-Bold", size: length * 0.0426))
                            .padding(.bottom, 5)
                        
                        TextField("Caption", text: $caption)
                            .padding(.horizontal)
                            .frame(width: UIScreen.main.bounds.width - 60)
                            .modifier(ColorBorderStyle(roundedCornes: 15, borderColor: Constants.ShadeTeal, backgroundColor: .white, textColor: .black))
                            .padding(.bottom)
                    }
                    
                    
                    HStack{
                        
                        Spacer()
                        
                        Button(action: {
                            
                            newPostData.post(card: CardModel(id: "", uid: "", tag: "tag", image: card.image, profileImage: hobbyData.userInfo.imageurl, username: hobbyData.userInfo.username, timePosted: Date(), hobby: hobbyData.selectedHobby.name, hobby_id: hobbyData.selectedHobby.id, hobbyImage: hobbyData.selectedHobby.name, isVideo: card.isVideo, description: caption, categories: selectedCategories, taggedPeople: newPostData.tagedPeople.map{$0.uid}, highlightedComment: nil, commentCount: 0), forward: true)
                            
                        }) {
                            Text("Create")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 60)
                                .modifier(ColorBorderStyle(roundedCornes: 15, borderColor: Constants.ShadeTeal, backgroundColor: .white, textColor: Constants.ShadeTeal))
                        }
                        
                        Spacer()
                        
                    }
                    
                    Spacer()

                }
                
            }
            .navigationBarHidden(true)
            .frame(width: UIScreen.main.bounds.width - 40, alignment: .center)
            .onAppear {
                caption = card.description
            }
            .alert(item: $newPostData.forwardAlertInfo) { alertinfo in
                Alert(title: Text(alertinfo.Title), message: Text(alertinfo.Message), dismissButton: .cancel(){
                    dismiss()
                })
            }
            //.padding(.horizontal, 20)
        }
//        .frame(width: length - 40, alignment: .center)
    }
}

//struct ForwardPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        ForwardPostView(newPostData: NewPostModel(), card: CardModel.emptyCard)
//    }
//}
