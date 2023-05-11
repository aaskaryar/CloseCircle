//
//  Password.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 6/6/22.
//

import SwiftUI
//import openssl_grpc

struct Password: View {
    @Environment(\.presentationMode) var presentationMode: Binding <PresentationMode>
    let ShadeTeal = Constants.ShadeTeal
    let textBG = Constants.textBG
    @State private var password: String = ""
    @State private var confirmpassword: String = ""
    @State private var action: Int? = 0
    @Binding var email:String
    @Binding var name: String
    
    @State var secure = true
    @State var confirmedSecure = true
    @State var invalidPassword = false
    @State var warningText = ""
    
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
                    Text("Password")
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
                
                ZStack{
                    
                    if secure{
                        SecureField(" password",text:$password)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                            .background(textBG)
                            .cornerRadius(12)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }else{
                        TextField(" password",text:$password)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                            .background(textBG)
                            .cornerRadius(12)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    
                    HStack{
                        
                        Spacer()
                        
                        Button(action: {
                            secure.toggle()
                        }){
                            Image(systemName: secure ? "eye" : "eye.slash")
                        }
                        .padding(.trailing, 20)
                    }
                }
                
                ZStack{
                    
                    if confirmedSecure{
                        SecureField(" confirm password",text:$confirmpassword)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                            .background(textBG)
                            .cornerRadius(12)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }else{
                        TextField(" confirm password",text:$confirmpassword)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                            .background(textBG)
                            .cornerRadius(12)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    
                    HStack{
                        
                        Spacer()
                        
                        Button(action: {
                            confirmedSecure.toggle()
                        }){
                            Image(systemName: confirmedSecure ? "eye" : "eye.slash")
                        }
                        .padding(.trailing, 20)
                    }
                }
                
                if invalidPassword{
                    
                    Text(warningText)
                        .font(Font.custom("DM Sans", size: 15))
                        .padding(.leading, 10)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    
                    if password != confirmpassword{
                        invalidPassword = true
                        warningText = "two passwords are not the same"
                    }else if password.count < 6{
                        invalidPassword = true
                        warningText = "password need to be at least 6 characters"
                    }else{
                        invalidPassword = false
                        action = 1
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
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
           
        NavigationLink(destination: Username(email:$email,password:$password,name:$name).navigationBarBackButtonHidden(true).navigationBarHidden(true), tag: 1, selection: $action) {
                EmptyView()
              }
              .hidden()
        
        
       
    }
}



