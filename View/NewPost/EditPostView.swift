//
//  EditPostView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/27/22.
//

import SwiftUI

struct EditPostView: View {
    
    var card : CardModel
    @Environment(\.dismiss) var dismiss
    @State var dis : Bool? = false
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            Button(action: {dismiss()}) {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .foregroundColor(.black)
            }
            .padding()
            
            PostPageView(card: card, dis: $dis)
        }
        .onChange(of: dis) { newValue in
            if newValue == true{
                dismiss()
            }
        }
    }
}
