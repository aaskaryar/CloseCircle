//
//  ServiceView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 5/1/22.
//

import SwiftUI

struct ServiceView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var settingsData : SettingViewModel
    @State var bug = ""
    var policy = ""
    
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
                        .foregroundColor(.black)
                        .padding(.trailing, 5)
                }
                
                Text(policy)
                    .font(Font.custom("DM Sans", size: 20))
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding()
            
            Text(policy)
//                .frame(width: UIScreen.main.bounds.width-40, height: 48)
//                .cornerRadius(15)
//                //.padding(.vertical,20)
//                .padding(EdgeInsets(top: 0, leading: 20, bottom:0 , trailing: 0))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 5)
//                        .stroke(lineWidth: 1.0)
//                )
            
            Spacer()
        }
    }
}
