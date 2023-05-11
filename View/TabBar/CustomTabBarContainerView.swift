//
//  CustomTabBarContainerView.swift
//  Tabs
//
//  Created by Aria Askaryar on 4/15/22.
//

import SwiftUI

struct CustomTabBarContainerView<Content:View>: View {
    @Binding var selection: TabBarItem
    let content : Content
    @State private var tabs: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>,@ViewBuilder content: () -> Content)
    {
        self._selection = selection
        self.content = content()
    }
    var body: some View {
        VStack(spacing: 0)
        {
            ZStack{
                content
            }
            CustomTabBarView(tabs: tabs,selection: $selection)
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self, perform:{value in
            self.tabs = value
        })
    }
}

struct CustomTabBarContainerView_Previews: PreviewProvider {
    static let tabs:[TabBarItem] = [
        TabBarItem(iconName: "house", title: "Home", color: Color.red),
        TabBarItem(iconName: "heart", title: "Favorites", color: Color.blue),
        TabBarItem(iconName: "person", title: "Profile", color: Color.green)
    ]
    static var previews: some View {
        CustomTabBarContainerView(selection: .constant(tabs.first!))
        {
            Color.red
        }
    }
}
