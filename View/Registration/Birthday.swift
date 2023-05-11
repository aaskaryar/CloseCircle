//
//  Birthday.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 6/6/22.
//

import SwiftUI

struct Birthday: View {
    @Environment(\.presentationMode) var presentationMode: Binding <PresentationMode>
    @EnvironmentObject var viewModel: RegistrationViewModel
    let ShadeTeal = Constants.ShadeTeal
    let textBG = Constants.textBG
    @State private var birthdate: String = ""
    @State private var action: Int? = 0
    //@State private var action: Bool = false
    @State var showDate: Bool = false
    @State private var birthDate = Date()
    @Binding var email:String
    @Binding var password:String
    @Binding var username:String
    @Binding var name:String
    
    @State var isLoading = false
    
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
                    Text("Birthday")
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
                
                TextField("Birthday", text: $birthdate)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                    .background(textBG)
                    .cornerRadius(12)
                    .onTapGesture {
                        showDate.toggle()
                    }
                
                if (!showDate) {
                    DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date) {}
                    .datePickerStyle(.wheel)
                    .padding(.trailing, 40)
                    .onChange(of: birthDate) { newValue in
                                   
                        birthdate = birthDate.formatted(.dateTime.day().month(.wide).year())
                    }
                }
                
                Button(action: {
                    withAnimation{
                        isLoading = true
                    }
                    
                    viewModel.signUp(email: email, password: password, username: username, name: name){ success in
                        withAnimation{
                            isLoading = false
                        }
                        if success{
                            //action = 1
                            action = 1
                            print("action success")
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
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
            VStack{
                
                Spacer()
                
                ProgressView()
                    .padding()
                    .background(
                        .regularMaterial,
                        in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                
                Spacer()
            }
            .opacity(isLoading ? 1 : 0)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
//        .sheet(isPresented: $action) {
//            WelcomeView(name: username)
//        }
            
        
        NavigationLink(destination: VerificationView(name: username)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true),
                       tag: 1,
                       selection: $action) {
            EmptyView()
          }
          .hidden()
        
        }
        
        
    
   
}

