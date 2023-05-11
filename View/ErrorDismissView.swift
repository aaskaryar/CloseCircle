//
//  ErrorDismissView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 8/1/22.
//

import SwiftUI

struct ErrorDismissView: View {
    @Environment(\.dismiss) var dismiss
    var error: String
    
    var body: some View {
        
        ZStack{
            
            VStack{
                
                HStack{
                    
                    Button(action: {
                        withAnimation(.easeInOut){
                            dismiss()
                        }
                    }) {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                            .padding(.trailing, 5)
                    }
                    
                    Spacer()
                    
                }
                
                Spacer()
            }
            
            Text("Error: \(error)")
        }
    }
}

