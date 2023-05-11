//
//  DropDownEditer.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/29/22.
//

import SwiftUI

struct DropDownEditer: View {
    
    @State var isExpanded = false
    var name = ""
    var default_name = ""
    @Binding var value : String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(name)
                .foregroundColor(.black)
                .font(Font.custom("DM Sans", size: 18))
                .fontWeight(.bold)
                .padding()
                .frame(width:UIScreen.main.bounds.width-20, height: 50, alignment: .leading)
                .background(Color(hex: 0xE4E7EC))
                .cornerRadius(7)
            
            if isExpanded {
                TextField(default_name, text: $value)
                    .frame(width: UIScreen.main.bounds.width-40, height: 48)
                    .cornerRadius(15)
                    //.padding(.vertical,20)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom:0 , trailing: 0))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 1.0)
                    )
            }
        }
        
    }
}
