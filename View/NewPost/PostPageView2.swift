//
//  PostPageView2.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/26/22.
//

import SwiftUI

struct PostPageView2: View {
    
    @EnvironmentObject var newPostData : NewPostModel
    @EnvironmentObject var hobbyData : HobbiesViewModel
    @State var caption: String = " "
    @State var selectedCategories : [String]
    //@State var hobby : HobbyModel = HobbyModel(id: "", name: "", url: "", privacy: "", uid: "", followers: [], categories: [])
    @State private var isEditing = false
    @State private var firstTime  = true
    //@FocusState var focus : Bool 
    let length = UIScreen.main.bounds.width - 40
    let fontSize = UIScreen.main.bounds.width * 16 / 375
    let smallerSize = UIScreen.main.bounds.width * 13 / 375
    @Environment(\.dismiss) var dismiss
    @State var card : CardModel?
    @State var editSelfPost : Bool = false
    @Binding var dis : Bool?
    @FocusState private var focus: Bool

    
    var body: some View {
        
        NavigationView{
            
            ZStack{
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading){
                        
                        //PhotoAssetDisplayer(card: card)
                        
                        Text("Add a Caption")
                            .font(.custom("DMSans-Bold", size: fontSize))
                            .padding(.top, 10)
                        
                        TextEditor(text: $caption)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 5)
                            .font(.custom("DMSans-Bold", size: fontSize))
                            .frame(width:UIScreen.main.bounds.width - 40, height: 150, alignment: .center)
                            .background(Constants.ShadeGray.cornerRadius(12))
                            .focused($focus)
                            .onTapGesture {
                                focus.toggle()
                            }
                        
                        
                         Text("Tag People")
                             .font(.custom("DMSans-Bold", size: fontSize))
                             .padding(.top, 10)
                         
                         
                         HStack{
                             
                             ScrollView(.horizontal,showsIndicators: false){
                                 
                                 HStack{
                                     
                                     ForEach(newPostData.tagedPeople, id: \.self){ user in
                                         
                                         Button(action: {
                                             
                                             if(isEditing){
                                                 newPostData.tagedPeople =  newPostData.tagedPeople.filter(){$0 != user}
                                             }
                                         }){
                                             Text("@\(user.username)")
                                                 .foregroundColor(isEditing ? .red : .black)
                                                 .font(Font.custom("DM Sans", size: smallerSize))
                                                 .fontWeight(.bold)
                                                 .lineLimit(1)
                                                 .padding(.horizontal, 10)
                                                 .padding(.vertical, 5)
                                                 .background(
                                                     Color(hex: 0xE4E7EC)
                                                     .cornerRadius(9)
                                                 )
                                         }
                                     }
                                     
                                     NavigationLink(destination:TagPeople(selectedPeople: $newPostData.tagedPeople).navigationBarHidden(true)){
                                         
                                         Image(systemName: "plus")
                                             .resizable()
                                             .frame(width: 12, height: 12)
                                             .foregroundColor(Color.white)
                                             .aspectRatio(contentMode: .fit)
                                             .background(Constants.ShadeTeal.frame(width: 20, height: 20) .clipShape(Circle()))
                                             .padding()
                                     }
                                 }
                             }

                             
                             Spacer()
                             
                             Button(action: {isEditing.toggle()}){
                                 
                                 Text(isEditing ? "Editing" : "Edit")
                                     .foregroundColor(isEditing ? .black : .white)
                                     .font(Font.custom("DM Sans", size: smallerSize))
                                     .fontWeight(.bold)
                                     .lineLimit(1)
                                     .padding(.horizontal, 10)
                                     .padding(.vertical, 5)
                                     .background(
                                         RoundedRectangle(cornerRadius: 9)
                                             .fill(isEditing ? Constants.ShadeGray : Constants.ShadeTeal)
                                         )
                             }
                         }
                         .padding(.bottom, 5)
                        
                        
                        HStack{
                            
                            Spacer()
                            
                            Button(action:{
                                dismiss()
                            }){
                                Text("Back")
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 50)
                                    .modifier(ColorBorderStyle(roundedCornes: 15, borderColor: Constants.ShadeTeal, backgroundColor: .white, textColor: Constants.ShadeTeal))
                            }
                            .padding(.leading, 5)
                            
                            Button(action: {
                                
                                if editSelfPost{
                                    guard let card = card else {return}
                                    newPostData.edit(card: card, caption: caption, hobby: hobbyData.selectedHobby, categories: selectedCategories)
                                }else{
                                    
                                    newPostData.post(card: CardModel(id: "", uid: "", tag: "tag", image: "", profileImage: hobbyData.userInfo.imageurl, username: hobbyData.userInfo.username, timePosted: Date(), hobby: hobbyData.selectedHobby.name, hobby_id: hobbyData.selectedHobby.id, hobbyImage: hobbyData.selectedHobby.name, isVideo: false, description: caption, categories: selectedCategories, taggedPeople: newPostData.tagedPeople.map{$0.uid}, highlightedComment: nil, commentCount: 0), forward: false)
                                }
                            }) {
                                
                                if editSelfPost{
                                    Text("Save")
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 50)
                                        .modifier(ColorBorderStyle(roundedCornes: 15, borderColor: Constants.ShadeTeal, backgroundColor: Constants.ShadeTeal, inbetweenColor: Constants.ShadeTeal, textColor: .white))
                                }else{
                                    Text("Post")
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 50)
                                        .modifier(ColorBorderStyle(roundedCornes: 15, borderColor: Constants.ShadeTeal, backgroundColor: Constants.ShadeTeal, inbetweenColor: Constants.ShadeTeal, textColor: .white))
                                }
                            }
                            
                            Spacer()
                                
                            
                        }
                        
                        Spacer()
                        
                    }
                    
                }
                .disabled(newPostData.isPosting ? true : false )
                .opacity(newPostData.isPosting ? 0.5 : 1)
                .padding(.top, 15)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .modifier(PhotoPickerModifier(result: $newPostData.result, showEditView: $newPostData.showEditView, picker: $newPostData.picker))
                .onAppear {
                    UITextView.appearance().backgroundColor = .clear
                    if let card = card{
                        caption = card.description
                        if isOwner(uid: card.uid){
                            editSelfPost = true
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 40, alignment: .center)
                //.opacity(newPostData.isPosting ? 0.5 : 1)
                .alert(item: $newPostData.newAlertInfo) { alertinfo in
                    Alert(title: Text(alertinfo.Title), message: Text(alertinfo.Message), dismissButton: .cancel(Text("Done"), action: {
                        dis = true
                        dismiss()
                    }))
                }
                
                ProgressView("Posting…", value: newPostData.postProgress, total: 100)
                    //.progressViewStyle(CircularProgressViewStyle(tint: Constants.ShadeGreen))
                    .frame(width: UIScreen.main.bounds.width - 40)
                    .opacity(newPostData.isPosting ? 1 : 0)
                
            }
        }
        .background(Color.white.ignoresSafeArea())
       
        
        
        
        //Spacer(minLength: 50)
    }
}
