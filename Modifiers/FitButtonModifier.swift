//
//  FitButtonModifier.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 8/10/22.
//

import SwiftUI

struct FitButtonModifier: ViewModifier {
    
    var cornerRadius: Double
    var backgroundColor : Color
    var foregroundColor : Color
    
    
    func body(content: Content) -> some View {
        
        content
            .foregroundColor(foregroundColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                backgroundColor.cornerRadius(cornerRadius)
            )
        
    }
}
