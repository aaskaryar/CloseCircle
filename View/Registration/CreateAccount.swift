//
//  CreateAccount.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 6/6/22.
//

import SwiftUI
struct CreateAccount: View {
    @Environment(\.presentationMode) var presentationMode: Binding <PresentationMode>
    @EnvironmentObject var viewModel: RegistrationViewModel
    let ShadeTeal = Constants.ShadeTeal
    let textBG = Constants.textBG
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var action: Int? = 0
    
    @State private var internetGood = true
    @State private var emailGood = true
    @State private var invalidEmail = false
    @State var checking : Bool = false
    
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
                    Text("Create an Account")
                        .font(Font.custom("DMSans-Bold", size: Constants.width * (30 / 375)))
                      //.fixedSize(horizontal: false, vertical: true)
                
                    Spacer()
                }
                .padding(.horizontal)
                
                
                Spacer()
            }
            
            
            VStack(alignment: .center){
                
                Spacer()
                
                TextField("Email",text:$email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                    .background(textBG)
                    .cornerRadius(12)
                
                HStack{
                    if !self.internetGood{
                        Text("Unable to check email, please check Internet Connection")
                            .font(Font.custom("DM Sans", size: 15))
                            .padding(.leading, 10)
                            .foregroundColor(.red)
                        
                    }else{
                        
                        if !self.emailGood{
                            Text("Email already used, please try another one")
                                .font(Font.custom("DM Sans", size: 15))
                                .padding(.leading, 10)
                                .foregroundColor(.red)
                        }else if self.invalidEmail{
                            Text("Email is not in correct format, please try again")
                                .font(Font.custom("DM Sans", size: 15))
                                .padding(.leading, 10)
                                .foregroundColor(.red)
                        }else{
                            EmptyView()
                        }
                    }
                    Spacer()
                }
                
                
                TextField("Full Name",text:$name)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                    .background(textBG)
                    .cornerRadius(12)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Button(action: {
                    
                    if email.isValidEmail{
                        invalidEmail = false
                        checking = true
                        
                        checkEmailDuplicated(email: email) { result in
                            print(result)
                            self.emailGood = result.result
                            checking = false
                            self.internetGood = result.connection
                            if result.result && result.connection{
                                action = 1
                                print("action")
                            }
                        }
                    }else{
                        invalidEmail = true
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
            
        NavigationLink(destination: Password(email:$email,name:$name).navigationBarBackButtonHidden(true).navigationBarHidden(true), tag: 1, selection: $action) {
                EmptyView()
              }
              .hidden()
        
        
       
    }
}

struct CreateAccount_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccount()
    }
}
