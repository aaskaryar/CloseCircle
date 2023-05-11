//
//  LoginView.swift
//  Testing
//
//  Created by Aria Askaryar on 4/24/22.
//

import SwiftUI
struct LoginView: View {
    @State private var action: Int? = 0
    @State private var username: String = ""
    @State private var password: String = ""
    @State var showDate: Bool = false
    @State private var birthDate = Date()
    @State var showProgressiveView = false
    let textBG = Constants.textBG
    let ShadeTeal = Constants.ShadeTeal
    @Environment(\.presentationMode) var presentationMode: Binding <PresentationMode>
    @EnvironmentObject var viewModel: RegistrationViewModel
    
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
                
                HStack{
                    
                    Text("Login")
                        .font(Font.custom("DMSans-Bold", size: Constants.width * (48 / 375)))
                  
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
                
                
                
                
                NavigationLink(destination: CreateAccount().navigationBarBackButtonHidden(true).navigationBarHidden(true), tag: 1, selection: $action) {
                    
                    EmptyView()
                  }
                  .hidden()
            }
            
            VStack(alignment: .center){
                
                Spacer()
                
                Group {
                    // need to add variables
                    TextField(" email", text: $username)
                          .padding()
                          .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                          .background(textBG)
                          .cornerRadius(12)
                          .padding(.bottom)
                      
                    SecureField(" password", text: $password)
                          .padding()
                          .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                          .background(textBG)
                          .cornerRadius(12)
                }
                
                Button(action: {
                    
                    guard !username.isEmpty, !password.isEmpty else {return}
                    
                    viewModel.signIn(username:username,password:password)
                    
                }) {
                    
                    Text("Continue")
                        .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                        .font(Font.custom("DM Sans", size: 20))
                        .foregroundColor(.white)
                        .background(ShadeTeal)
                        .cornerRadius(12)
                  }
                  .padding(.top)
                  .cornerRadius(12)
                
//                HStack{
//
//                    Spacer()
//
//                    Text("Forget Password?")
//                        .foregroundColor(ShadeTeal)
//                        .font(Font.custom("DM Sans", size: 12))
//                        .opacity(0.5)
//
//                    Spacer()
//                }


                Button(action: {

                }) {
                    Text("Forget Password?")
                        .foregroundColor(ShadeTeal)
                        .font(Font.custom("DM Sans", size: 15))
                        .opacity(0.8)
                }
                .padding()
//
                
                Spacer()
                
                Text("Don't Have an Account?")
                    .font(Font.custom("DM Sans", size: 12))
                    .opacity(0.5)
                    .padding(2)
                
                Button(action: {action = 1}) {
                    Text("Sign Up")
                        .font(Font.custom("DM Sans", size: 20))
                        .foregroundColor(ShadeTeal)
                }
                .padding(.bottom, 50)
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
            .opacity(viewModel.tryingToLogin ? 1 : 0)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .alert(item: $viewModel.loginStatus) { result in
            Alert(title: Text(result.result), message: Text(result.message), dismissButton: .cancel())
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
