//
//  LoadingModifier.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/29/22.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
    @Binding var isLoading: Bool
    var transparent: Bool
    var loadingOpacity : Double
    
    init(isLoading: Binding<Bool>, transparent: Bool = true){
        _isLoading = isLoading
        self.transparent = transparent
        loadingOpacity = transparent ? 0.5 : 0
    }
    
    func body(content: Content) -> some View {
        
        
        
        content
            .disabled(isLoading)
            .opacity(isLoading ? loadingOpacity : 1)
            .overlay(
                ProgressView()
                    .padding()
                    .background(
                        .regularMaterial,
                        in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .opacity(isLoading ? 1 : 0)
            )
            .navigationBarHidden(true)
            .if(!transparent) { view in
                view.background(Color.black.ignoresSafeArea())
            }
        
    }
}

