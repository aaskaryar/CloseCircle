//
//  VerificationView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 6/25/22.
//

import Foundation
import SwiftUI

struct VerificationView: View {
    
    @EnvironmentObject var viewModel: RegistrationViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var Title : String = ""
    @State var Message : String = ""
    @State var present : Bool = false
    @State var isLoading : Bool = false

    @State private var action: Int? = 0
    
    let length = UIScreen.main.bounds.width
    let name : String

    var body: some View{
        
        ZStack{
            
            VStack{
                
                HStack{
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                        
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 30)
                
                HStack {
                    
                    Text("Verify")
                        .font(Font.custom("DMSans-Bold", size: length * 48 / 375))
                        .lineLimit(1)
                        
                    Spacer()
//                    
//                    Image("ShadeLogo")
//                        .frame(width: 50, height: 50)
                }
                
                Spacer()
                
                
            }
            
            VStack{
                
                Spacer()
                
                Group{
                    Text("We Sent you an ") +
                    Text("Email").foregroundColor(Constants.ShadeTeal)
                }
                .font(Font.custom("DMSans-Bold", size: CGFloat(Int(length * 0.064))))
                
//                Text("Please check your inbox")
//                    .font(Font.custom("DMSans-Bold", size: CGFloat(Int(length * 0.074))))
                
                Group{
                    Text("Please ") +
                    Text("Verify your Account").foregroundColor(Constants.ShadeTeal)
                }
                .font(Font.custom("DMSans-Bold", size: CGFloat(Int(length * 0.064))))
                .padding(.bottom)
                
                Text("[Check the Junk Folder]")
                    .font(Font.custom("DMSans-Regular", size: CGFloat(Int(length * 0.03))))
                    .foregroundColor(.black)
                    .opacity(0.5)
                    .padding(.bottom, 20)
                
                Button(action: {
                    
                    viewModel.checkVerfication(){ result in
                        //print("result ", result)
                        self.Title = result ? "Success" : "Error"
                        self.Message = result ? "Your Email Address has been Verified" : "Please Try Again"
                        self.present = !result
                        //print("present ", present)
                       
                        if result{
                            action = 1
                        }
                    }
                    
                    
                }) {
                    Text("Continue")
                        .frame(width: length - 40, height: 50)
                        .font(Font.custom("DM Sans", size: 20))
                        .foregroundColor(.white)
                        .background(ShadeTeal)
                        .cornerRadius(12)
                }
                
                Spacer()
                
            }
            
            VStack{
                
                Spacer()
                
                Text("Did not Receive an Email?")
                    .foregroundColor(Color(hex: 0x636366))
                    .font(Font.custom("DMSans", size: 14))
                    
                
                Button(action: {
                    viewModel.resendVerificationEmail(){ success in
                        
                        self.Title = success ? "Success" : "Error"
                        self.Message = success ? "Your Email has been Resent" : "Please Try Again"
                        self.present = true
                    }
                }) {
                    Text("Resend Confirmation")
                        .font(Font.custom("DMSans-Bold", size: 20))
                        .foregroundColor(Constants.ShadeTeal)
                }
                .padding(.bottom, 85)
                
            }
            
            NavigationLink(destination: WelcomeView(name: username).navigationBarBackButtonHidden(true).navigationBarHidden(true),
                           tag: 1,
                           selection: $action)
            {
                EmptyView()
            }
            .hidden()
            
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
        .frame(width: length * 0.1067)
        .alert(isPresented: $present) {
            Alert(title: Text(Title), message: Text(Message), dismissButton: .cancel())
        }
        
    }
    
}
