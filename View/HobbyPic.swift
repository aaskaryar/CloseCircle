//
//  HobbyPic.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 5/22/22.
//

import SwiftUI

struct HobbyPic: View {
    
    var frame : CGFloat
    var hobby : String
    var backgroundColor : Color
    var foregroundColor : Color
    
    var body: some View {
        
        if(Constants.names.contains(hobby.lowercased())){
            if backgroundColor == Constants.ShadeGreen{
                Image(hobby.lowercased() + "2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: frame, height: frame)
            }
            else{
                Image(hobby.lowercased())
                    .resizable()
                    .scaledToFill()
                    .frame(width: frame, height: frame)
            }
        }else{
            Text(hobby.prefix(1).uppercased())
                .font(Font.custom("DM Sans", size: frame/2))
                .foregroundColor(foregroundColor)
                .fontWeight(.bold)
                .frame(width: frame, height: frame)
                .background(
                    backgroundColor
                        .frame(width: frame, height: frame, alignment: .center)
                        .clipShape(Circle())
                )
        }
    }

}
