//
//  LoadingView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 5/11/22.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack{
            Text("CloseCircle")
                .font(Font.custom("DM Sans", size: 35))
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}
