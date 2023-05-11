//
//  InvitePeople.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 8/12/22.
//

import SwiftUI

struct InvitePeople: View {
    @Environment(\.dismiss) var dismiss
    //EnvironmentObject var newPostdata : NewPostModel
    @EnvironmentObject var searchData : SearchViewModel
    @EnvironmentObject var inviteData : InviteViewModel
    @State var selectedPeople : [UserModel] = [UserModel]()
    @State private var searchText = ""
    @State private var editing = false
    @State var alertInfo : AlertInfo?
    var hobby : HobbyModel
    
    var body: some View {
        
        VStack{
            
            HStack{
                
                SearchBar(text: $searchText.onChange(searchTextChanged))
                    .padding(.leading, 10)
                    .background(
                        Color.white
                    )
                
                Spacer()
                
                Button("Invite") {
                    
                    alertInfo = AlertInfo(Title: "Confirm Invite", Message: "You cannot Undo Invites")
                }
                .padding(.trailing, 10)
            }
            .background(
                Color.white
                    .frame(width: UIScreen.main.bounds.size.width)
                    .shadow(color: .gray, radius: 3, x: 0, y: 3)
                    .mask(Rectangle().padding(.bottom, -20)) /// here!
                
            )
            
            if(!selectedPeople.isEmpty){
                
                HStack{
                    
                    VStack(alignment: .leading){
                        
                        Text("Invited")
                            .font(.footnote)
                        
                        ScrollView(.horizontal,showsIndicators: false){
                            
                            HStack{
                                
                                ForEach(selectedPeople, id: \.self){ user in
                                    
                                    EquatableWebImage(url: user.imageurl, size: 30, shape: Circle())
                                        .equatable()
                                        .overlay(
                                            
                                            Group{
                                                if(editing){
                                                    Button(action: {
                                                        selectedPeople =  selectedPeople.filter(){$0 != user}
                                                    }){
                                                        
                                                        Image(systemName: "minus.circle.fill")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 30, height: 30)
                                                            .foregroundColor(.gray)
                                                            .opacity(0.7)
                                                    }
                                                }
                                            }
                                            
                                        )
                                }
                            }
                            
                        }
                        
                    }
                    
                    Spacer()
                    
                    Button(action: {editing.toggle()}){
                        
                        if(editing){
                            
                            Text("editing")
                                .foregroundColor(.black)
                                .font(Font.custom("DM Sans", size: 14))
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .padding(.horizontal)
                                .background(
                                    Constants.ShadeGray
                                        .frame(height: 30)
                                        .cornerRadius(9)
                                )
                        }else{
                            
                            Text("edit")
                                .foregroundColor(.white)
                                .font(Font.custom("DM Sans", size: 14))
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .lineLimit(1)
                                .background(
                                    Constants.ShadeGreen
                                        .frame(height: 30)
                                        .cornerRadius(9)
                                )
                        }
                        
                    }

                }
                .frame(width: UIScreen.main.bounds.width - 30)
            }
            
            List{
                
                ForEach(searchData.recommandtionId, id: \.self){ userId in
                    
                    let user : UserModel = searchData.recommandtion[userId]!
                    
                    HStack{
                        
                        EquatableWebImage(url: user.imageurl, size: 30, shape: Circle())
                        
                        VStack(alignment: .leading, spacing: 0){
                            
                            Text(user.username)
                                .font(Font.custom("DM Sans", size: 14))
                            
                            Text(user.real_name)
                                .font(Font.custom("DM Sans", size: 10))
                                .opacity(0.44)
                            
                            
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            
                            if(selectedPeople.contains(user)){
                                let alert = UIAlertController(title:"Error", message: "Already Tagged", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title:"Ok",style: .default))
                                UIApplication.shared.windows.first?.rootViewController?.present(alert,animated: true)
                            }else{
                                selectedPeople.append(user)
                            }
                            
                        }){
                            
                            ZStack{
                                Color.teal
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 17, height: 17)
                                    .foregroundColor(Color.white)
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                        
                    }
                }
                
            }
            .background(.white)
            
            
            Spacer()
            
        }
        .navigationBarHidden(true)
        .alert(item: $alertInfo) { alertinfo in
            Alert(title: Text(alertinfo.Title), message: Text(alertinfo.Message), primaryButton: .default(Text("Confirm"), action: {
                
                for user in selectedPeople{
                    inviteData.sendInvite(hobby: hobby, toUserInfo: user)
                }
                dismiss()
            }) ,secondaryButton: .cancel())
        }
    }
    
    func searchTextChanged(to value: String) {
        searchData.search(searchText: searchText)
    }
}
//
//struct InvitePeople_Previews: PreviewProvider {
//    static var previews: some View {
//        InvitePeople()
//    }
//}
