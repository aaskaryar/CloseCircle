//
//  InviteOnboardView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 8/12/22.
//

import SwiftUI

struct InviteOnboardView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var realName : String = ""
    @State var email : String = ""
    let textBG = Constants.textBG
    
    var body: some View {
        VStack{
            
            HStack{
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 5)
                        .foregroundColor(.black)
                }
                
                Text("Invite a Friend")
                    .font(Font.custom("DM Sans", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
                
            }
            .padding(.bottom)
            
            
            TextField("Friend's Name",text: $realName)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                .background(textBG)
                .cornerRadius(12)
            
            
            TextField("Friend's Email",text: $email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                .background(textBG)
                .cornerRadius(12)
            
            Button {
                ref.collection("onBoardRequests").document().setData([
                    "real name" : realName,
                    "email" : email
                ])
                
                dismiss()
            } label: {
                Text("Invite")
                    .padding(.horizontal, 20)
                    .modifier(ColorBorderStyle(roundedCornes: 10, borderColor: Constants.ShadeGreen, backgroundColor: Constants.ShadeGreen, inbetweenColor: .white, textColor: .white))
            }
            .padding()

            
            
            Spacer()
        }
        .padding()
    }
}

struct InviteOnboardView_Previews: PreviewProvider {
    static var previews: some View {
        InviteOnboardView()
    }
}
