//
//  Username.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 6/6/22.
//

import SwiftUI

struct Username: View {
    @Environment(\.presentationMode) var presentationMode: Binding <PresentationMode>
    let ShadeTeal = Constants.ShadeTeal
    let textBG = Constants.textBG
    @State private var username: String = ""
    @State private var action: Int? = 0
    @Binding var email:String
    @Binding var password:String
    @Binding var name: String
    
    @State private var checking = false
    @State private var usernameGood = true
    @State private var internetGood = true
    @State private var warningMessage = ""
    
    var body: some View {
        ZStack{
            
            VStack(alignment: .leading){
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                }
                .padding()
                
                HStack {
                    Text("Username")
                        .font(Font.custom("DMSans-Bold", size: Constants.width * (40 / 375)))
                      //.fixedSize(horizontal: false, vertical: true)
                
                    Spacer()
                    
//                    Image("ShadeLogo")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: Constants.width * (40 / 375), height: Constants.width * (40 / 375))
                }
                .padding(.horizontal)
                
                
                Spacer()
            }
            
            VStack{
                
                Spacer()
                
                TextField(" username",text:$username)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                    .background(textBG)
                    .cornerRadius(12)
                
                if !internetGood || !usernameGood{
                    Text(warningMessage)
                        .font(Font.custom("DM Sans", size: 15))
                        .padding(.leading, 10)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    
                    checking = true
                    
                    checkUsernameDuplicated(username: username) { result in
                        print(result)
                        checking = false
                        self.usernameGood = result.result
                        self.internetGood = result.connection
                        
                        if !self.internetGood{
                            self.warningMessage = "Unable to check username, please check Internet Connection"
                        }else if !self.usernameGood{
                            self.warningMessage = "Username already in use, please try another one"
                        }else{
                            action = 1
                        }
                    }
                    
                }) {
                    Text("Continue")
                      .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                      .font(Font.custom("DM Sans", size: 20))
                      .foregroundColor(.white)
                      .background(ShadeTeal)
                      .cornerRadius(12)
                  }
                  .padding(.top, 20)
                  .cornerRadius(12)
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
            .opacity(checking ? 1 : 0)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
            
        NavigationLink(destination: Birthday(email: $email, password: $password, username: $username,name:$name).navigationBarBackButtonHidden(true).navigationBarHidden(true), tag: 1, selection: $action) {
                EmptyView()
              }
              .hidden()
        }
        
       
}


