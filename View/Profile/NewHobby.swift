//
//  NewPost.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/10/22.
//

import SwiftUI

struct NewHobby: View {
    
    @StateObject var newHobbyData = NewHobbyModel()
    @State var presenting : Bool = false
    @Environment(\.presentationMode) var present
    
    var body: some View {
        VStack{
            
            HStack{
                
                Text("New Hobby")
                    .font(Font.custom("DMSans-Bold", size: 30))
                    
                
                Spacer(minLength: 0)
                
                Button(action: {
                    
                    present.wrappedValue.dismiss()}){
                    
                    Text("Cancel")
                            .font(Font.custom("DMSans-Bold", size: 20))
                }
                
            }
            .padding()
            .opacity(newHobbyData.isPosting ? 0.5 : 1)
            .disabled(newHobbyData.isPosting ? true : false )
            
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
                if newHobbyData.img_Data.count != 0{
                    Image(uiImage: UIImage(data: newHobbyData.img_Data)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .cornerRadius(15)
                }else{
                    Image("default")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .cornerRadius(15)
                    
                }
            }
            .padding()
            .contentShape(Rectangle())
            .opacity(newHobbyData.isPosting ? 0.5 : 1)
            .disabled(newHobbyData.isPosting ? true : false )
            .frame(width: 200, height: 200)
            .onTapGesture {
                newHobbyData.picker.toggle()
            }
            .overlay(
                VStack{
                    Spacer()
                    ZStack{
                        
                        VisualEffectView(effect: UIBlurEffect(style: .dark))
                            .frame(width: 200, height: 40, alignment: .bottom)
                            .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                        
                        
                        HStack{
                            
                            
                            Spacer()
                            
                            if(newHobbyData.hobbyName != ""){
                                if(Constants.names.contains(newHobbyData.hobbyName.lowercased())){
                                    Image(newHobbyData.hobbyName.lowercased())
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 20, height: 20)
                                }else{
                                    Text(newHobbyData.hobbyName.prefix(1).uppercased())
                                        .font(Font.custom("DM Sans", size: 10))
                                        .fontWeight(.bold)
                                        .frame(width: 20, height: 20)
                                        .background(
                                            Color(hex: 0xE4E7EC)
                                                .frame(width: 20, height: 20, alignment: .center)
                                                .clipShape(Circle())
                                        )
                                }
                            }
                            
                            
                            Text(newHobbyData.hobbyName)
                                .font(Font.custom("DM Sans", size: 15))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                        }
                            
                    }
                }
                    .opacity(newHobbyData.isPosting ? 0.5 : 1)
            )
                
            TextField("Name", text: $newHobbyData.hobbyName)
                .padding()
                .frame(width: UIScreen.main.bounds.width-40, height: 48)
//                .cornerRadius(15)
//                //.padding(.vertical,20)
//                .padding(EdgeInsets(top: 0, leading: 20, bottom:0 , trailing: 0))
                .modifier(ColorBorderStyle(roundedCornes: 15, borderColor: Constants.ShadeTeal, backgroundColor: .white, textColor: .black))
                .opacity(newHobbyData.isPosting ? 0.5 : 1)
                .disabled(newHobbyData.isPosting ? true : false )
//                .overlay(
//                    RoundedRectangle(cornerRadius: 5)
//                        .stroke(lineWidth: 1.0)
//                )
        
            DropdownSelector(
                placeholder: "Privacy",
                options: [
                    DropdownOption(key: "1", value: Constants.Public),
                    DropdownOption(key: "2", value: Constants.Private),
                    DropdownOption(key: "3", value: Constants.Own),
                ], width: UIScreen.main.bounds.width-40,
                text: $newHobbyData.hobbyPrivate
                , presenting: $presenting)
//                .frame(width: UIScreen.main.bounds.width-40, height: 48)
//                .modifier(ColorBorderStyle(roundedCornes: 15, borderColor: Constants.ShadeTeal, backgroundColor: .white, textColor: .black))
                .zIndex(1)
            
            Button(action:  {
                closeKeyboard()
                newHobbyData.createHobby(present: present)
            }) {
                
                Text("Create!")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.vertical,10)
                    .padding(.horizontal,25)
                    .background(Color.white)
                    .clipShape(Capsule())
            }
            .opacity(presenting ? 0 : 1)
            
            Spacer()
            
        }
        .background(Color.white)
        .sheet(isPresented: $newHobbyData.picker){
            
            ImagePicker(picker:$newHobbyData.picker, img_Data: $newHobbyData.img_Data)
        }
        .alert(item: $newHobbyData.newHobbyAlertInfo) { info in
            Alert(title: Text(info.Title), message: Text(info.Message), dismissButton: .cancel(Text("Ok"), action: {
                if info.Title == "Success"{
                    present.wrappedValue.dismiss()
                }
            }))
        }
    }
    
    
    func closeKeyboard() {
        UIApplication.shared.sendAction(
          #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
        )
      }
}

