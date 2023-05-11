//
//  PostPageView.swift
//  Testing
//
//  Created by Aria Askaryar
//

import SwiftUI
import AVKit

struct PostPageView: View {
    let names = Constants.names
    let textBG = Constants.textBG
    let compBG = Constants.ShadeGreen
//    let newCard = CardModel(image: UIImage(named: "newImage"))
    
    @EnvironmentObject var newPostData : NewPostModel
    @EnvironmentObject var hobbyData : HobbiesViewModel
    
    @State private var selectedCategories : [String] = [String]()
    //@State var hobby : HobbyModel = HobbyModel(id: "", name: "", url: "", privacy: "", uid: "", followers: [], categories: [])
    @State private var firstTime  = true
    @FocusState var focus : Bool
    let length = UIScreen.main.bounds.width - 40
    let fontSize = UIScreen.main.bounds.width * 16 / 375
    let smallerSize = UIScreen.main.bounds.width * 13 / 375
    @State var card : CardModel?
    @Binding var dis : Bool?
    
    var body: some View {
        
        NavigationView{
            
            VStack(alignment: .leading){
                
                PhotoAssetDisplayer(card: card)
                
                Text("Select a Hobby")
                    .font(.custom("DMSans-Bold", size: fontSize))
                    .padding(.top, 15)
                
                HStack{
                    
                    ScrollView(.horizontal,showsIndicators: false){
                        
                        HStack{
                            
                            if(hobbyData.hobbies.count != 0){
                                
                                ForEach(hobbyData.hobbies) { hobby in
                                    
                                    VStack{
                                        
                                        Button(action:{
                                            
                                            withAnimation{
                                                
                                                if hobbyData.selectedHobby != hobby{
                                                    selectedCategories.removeAll()
                                                }
                                                hobbyData.selectedHobby = hobby
                                            }
                                            
                                        }){
                                            
                                            let onFocus = hobbyData.selectedHobby.name == hobby.name
                                            
                                            HobbyPic(frame: 50, hobby: hobby.name, backgroundColor: onFocus ? Constants.ShadeGreen : Constants.ShadeGray, foregroundColor: onFocus ? .white : .black)
                                        }
                                        //.padding()
                                        
                                        Text(hobby.name)
                                            .foregroundColor(.black)
                                            .font(Font.custom("DM Sans", size: smallerSize))
                                    }
                                    .padding(.trailing, 5)
                                }
                            }
                            
                            NavigationLink(destination:NewHobby().navigationBarHidden(true)){
                                
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(Color.white)
                                    .aspectRatio(contentMode: .fit)
                                    .background(Constants.ShadeTeal.frame(width: 20, height: 20) .clipShape(Circle()))
                                    .padding()
                            }
                        }
//                            .disabled(newPostData.isPosting ? true : false )
//                            .padding(.vertical, 10)
                        //.padding(.leading,10)
                       // .padding(.leading,)
                        //.padding(.trailing,20)
                    }
                }
                
                Text("Add Categories to Post")
                    .font(.custom("DMSans-Bold", size: fontSize))
                    .padding(.top, 10)
                
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
                                    .font(Font.custom("DM Sans", size: smallerSize))
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                    .background(
                                        
                                        Group{
                                            
                                            if(selectedCategories.contains(category)){
                                                Constants.ShadeGreen
                                            }else{
                                                Constants.ShadeGray
                                            }
                                        }
                                        .clipShape(Capsule())
                                    )
                            }
                        }
                        
                        NavigationLink(destination:NewCategoryView(hobbyData: hobbyData, hobby: hobbyData.selectedHobby, operation: hobbyData.addCategories(id: tag:)).navigationBarHidden(true)){
                            
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundColor(Color.white)
                                .aspectRatio(contentMode: .fit)
                                .background(Constants.ShadeTeal.frame(width: 20, height: 20) .clipShape(Circle()))
                                .padding()
                            
                        }
                    }
//                            .disabled(newPostData.isPosting ? true : false )
//                            .opacity(newPostData.isPosting ? 0.5 : 1)
                }
                    .padding(.bottom)
                
                HStack{
                    
                    Spacer()
                    
                    NavigationLink {
                        PostPageView2(selectedCategories: selectedCategories, card: card, dis: $dis)
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Next")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 50)
                            .modifier(ColorBorderStyle(roundedCornes: 15, borderColor: Constants.ShadeTeal, backgroundColor: Constants.ShadeTeal, inbetweenColor: Constants.ShadeTeal, textColor: .white))
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
//                .disabled(newPostData.isPosting ? true : false )
//                .opacity(newPostData.isPosting ? 0.5 : 1)
            .padding(.top, 15)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            //.padding(.top, 10)
//            .sheet(isPresented: $newPostData.picker) {
//
//                ImagePicker(picker: $newPostData.picker, img_Data: $newPostData.img_Data)
//            }
            .modifier(PhotoPickerModifier(result: $newPostData.result, showEditView: $newPostData.showEditView, picker: $newPostData.picker))
            .onChange(of: hobbyData.hobbies){ newHobby in
                if(newHobby.count != 0 && firstTime){
                    hobbyData.selectedHobby = newHobby[0]
                    firstTime = false
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                UITextView.appearance().backgroundColor = .clear
                if let card = card{
                    fetchHobby(uid: card.uid, hid: card.hobby_id, refresh: false) { hobby in
                        if let hobby = hobby {
                            hobbyData.selectedHobby = hobby
                        }
                    }
                    if let categories = card.categories{
                        selectedCategories = categories
                    }
                    if let taggedPeopleId = card.taggedPeople{
                        var taggedPeople = [UserModel]()
                        for uid in taggedPeopleId{
                            fetchUser(uid: uid) { userInfo in
                                if let userInfo = userInfo{
                                    taggedPeople.append(userInfo)
                                }
                                if taggedPeopleId.firstIndex(of: uid) == taggedPeopleId.count - 1{
                                    newPostData.tagedPeople = taggedPeople
                                }
                            }
                        }
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width - 40, alignment: .center)
            .opacity(newPostData.isPosting ? 0.5 : 1)
//            .alert(item: $newPostData.newAlertInfo) { alertinfo in
//                Alert(title: Text(alertinfo.Title), message: Text(alertinfo.Message), dismissButton: .cancel(Text("Done")))
//            }
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
        
        //Spacer(minLength: 50)
    }
}

//struct PostPageView_Previews: PreviewProvider {
//    static var previews: some View {
////        PostPageView()
//    }
//}
//
//extension View {
///// Layers the given views behind this ``TextEditor``.
//    func textEditorBackground<V>(@ViewBuilder _ content: () -> V) -> some View where V : View {
//        self
//            .onAppear {
//                UITextView.appearance().backgroundColor = .clear
//            }
//            .background(content())
//    }
//}
