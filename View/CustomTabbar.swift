//
//  CustomTabbar.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/1/22.
//

import SwiftUI

struct CustomTabbar: View {
    @Binding var selectedTab:String
    var body: some View {
        HStack(spacing:65)
        {
            TabButton(title: Constants.Home, image: "house", selectedTab: $selectedTab)
            TabButton(title: Constants.Capture, image: "camera", selectedTab: $selectedTab)
            TabButton(title: Constants.Profile, image: "person", selectedTab: $selectedTab)
        }
        .padding(.horizontal)
        .background(Color.white)

    }
}
struct TabButton:View {
    var title: String
    var image: String
    @Binding var selectedTab: String
    var body: some View{
        Button(action: {selectedTab = title})
        {
            VStack(spacing:5 )
            {
                Image(systemName: image)
                    .renderingMode(.template)
                    .foregroundColor(selectedTab == title ? Constants.ShadeGreen : Color.gray)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .foregroundColor(selectedTab == title ? Constants.ShadeGreen : Color.gray)
            .padding(.horizontal)
            .padding(.vertical,5)
        }
    }
}


