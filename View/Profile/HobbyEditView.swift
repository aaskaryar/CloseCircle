//
//  HobbyEditView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/6/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct HobbyEditView: View {
    
    @StateObject var newHobbyData = NewHobbyModel()
    @State var hobby : HobbyModel
    @State var alertInfo : AlertInfo?
    @State var presenting : Bool = false
    //@State var loading : Bool = false
    @Environment(\.presentationMode) var present
    
    var body: some View {
        
        ZStack{
            
            VStack{
                
                HStack{
                    
                    Text("Edit Hobby")
                        .font(Font.custom("DMSans-Bold", size: 30))
                        .foregroundColor(.black)
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        
                        present.wrappedValue.dismiss()
                        
                    }){
                        
                        Text("Cancel")
                            .font(Font.custom("DMSans-Bold", size: 20))
                            .foregroundColor(.black)
                    }
                    
                }
                .padding()
                .opacity(newHobbyData.isPosting ? 0.5 : 1)
                .disabled(newHobbyData.isPosting ? true : false )
                
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
                    
                    if !newHobbyData.img_Data.isEmpty{
                        Image(uiImage: UIImage(data: newHobbyData.img_Data)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .cornerRadius(15)
                    }else{
                        
                        EquatableWebImage(url: hobby.url, size: 200, shape: RoundedRectangle(cornerRadius: 15))
                            .equatable()
                            .padding(5)
                        
//                        FadeableWebImage{
//                            WebImage(url: URL(string: hobby.url))
//                                .resizable()
//                        }
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 200, height: 200)
//                        .cornerRadius(15)
                    
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
                        
                        HStack{
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    newHobbyData.img_Data.removeAll()
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                    .foregroundColor(.black)
                                    .background(
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Constants.ShadeGray)
                                            .frame(width: 30, height: 30)
                                    )
                            }
                            .padding(.top)
                            .padding(.trailing)
                        }
                        
                        Spacer()
                        
                        ZStack{
                            
                            VisualEffectView(effect: UIBlurEffect(style: .dark))
                                .frame(width: 200, height: 40, alignment: .bottom)
                                .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                            
                            
                            HStack{
                                
                                
                                Spacer()
                                
                                HobbyPic(frame: 20, hobby: hobby.name, backgroundColor: Constants.ShadeGray, foregroundColor: .white)
                                
                                
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
                .padding(.bottom)
                    
                TextField("Name", text: $newHobbyData.hobbyName)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width-40, height: 48)
                    .modifier(ColorBorderStyle(roundedCornes: 15, borderColor: Constants.ShadeTeal, backgroundColor: .white, textColor: .black))
                    .opacity(newHobbyData.isPosting ? 0.5 : 1)
                    .disabled(newHobbyData.isPosting ? true : false )
                    .overlay(
                        HStack{
                            Spacer()
                            
                            Button {
                                newHobbyData.hobbyName = hobby.name
                            } label: {
                                Image(systemName: "arrow.clockwise")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                                    .foregroundColor(.black)
                            }
                            .padding(.trailing)


                        }
                    )
            
                
                DropdownSelector(
                    placeholder: "Privacy",
                    options: [
                        DropdownOption(key: "1", value: Constants.Public),
                        DropdownOption(key: "2", value: Constants.Private),
                        DropdownOption(key: "3", value: Constants.Own),
                    ],
                    width: UIScreen.main.bounds.width-40,
                    text: $newHobbyData.hobbyPrivate, presenting: $presenting)
    //                .onTapGesture(perform: {
    //                    <#code#>
    //                })
                    .zIndex(1)
                
                Button(action:  {
                    
                    newHobbyData.editHobby(hobby: hobby)
                    //alertInfo = AlertInfo(Title: "Edit Success", Message: "")
                }) {
                    
                    Text("Save")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical,15)
                        .padding(.horizontal,50)
                        .background(Constants.ShadeTeal)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
                .opacity(presenting ? 0 : 1)
                .zIndex(10)
                
                Spacer()
                
            }
            
            VStack{
                
                Spacer()
                
                ProgressView()
                    .padding()
                    .background(
                        .regularMaterial,
                        in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                
                Spacer()
            }
            .opacity(newHobbyData.isPosting ? 1 : 0)
            
        }
        .background(Color.white)
        .sheet(isPresented: $newHobbyData.picker){
            
            ImagePicker(picker:$newHobbyData.picker, img_Data: $newHobbyData.img_Data)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            newHobbyData.hobbyPrivate = hobby.privacy
            newHobbyData.hobbyName = hobby.name
        }
        .alert(item: $newHobbyData.editHobbyAlertInfo) { info in
            Alert(title: Text(info.Title), message: Text(info.Message), dismissButton: .cancel(Text("ok"), action:{
                if info.Title == "Edit Success"{
                    present.wrappedValue.dismiss()
                }
            }))
        }
    }
}

//struct HobbyEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        HobbyEditView()
//    }
//}
