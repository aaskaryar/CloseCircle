//
//  SearchColumn.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 5/23/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchColumn: View {
    
    @ObservedObject var searchData : SearchViewModel
    var user: UserModel
    
    var body: some View {
        
        
        NavigationLink( destination: SearchSettingsView(userInfo: user).navigationBarHidden(true)){
            
            HStack{
                
                EquatableWebImage(url: user.imageurl, size: 30, shape: Circle())
                
                
                VStack(alignment: .leading, spacing: 0){
                    
                    Text(user.username)
                        .font(Font.custom("DM Sans", size: 14))
                    
                    Text(user.real_name)
                        .font(Font.custom("DM Sans", size: 10))
                        .opacity(0.44)
                    
                }
                
                Spacer()
                
            }
        }
        .padding(.vertical, 5)
    }
}
