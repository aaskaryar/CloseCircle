//
//  EditButton.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/29/22.
//

import SwiftUI

struct EditNaviButton: View {
    
    var type : String
    var value : String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        HStack{
            
            Text(type)
                .font(Font.custom("DM Sans", size: 18))
                .fontWeight(.bold)
            
            Spacer()
            
            Text(value)
                .font(Font.custom("DM Sans", size: 18))
                .fontWeight(.bold)
                
            
            Image(systemName: "arrow.right")
                .resizable()
                .scaledToFit()
                .frame(width: 20)
            
            
        }
        .padding()
        .frame(width:UIScreen.main.bounds.width-20, height: 50, alignment: .leading)
        .background(Color(hex: 0xE4E7EC))
        .cornerRadius(7)
        .foregroundColor(colorScheme == .dark ? .white : .black)
    }
}
