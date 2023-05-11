//
//  HobbiesView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/12/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchHobbiesView: View {
    
    @ObservedObject var searchUserData : SearchUserModel
    var body: some View {
        
        let columns = [
                GridItem(.adaptive(minimum: 125))
            ]
        
        VStack{
            
            if searchUserData.hobbies.isEmpty{
                
                Spacer(minLength: 0)
                
                Text("No Hobbies !!!")
                    .padding(.vertical, 50)
                
                Spacer(minLength: 0)
            }
            else{
                
                ScrollView{
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        
                        ForEach(searchUserData.hobbies) { hobby in
                            
                            if hobby.privacy != Constants.Own{
                                SearchHobbyBlock(hobby: hobby, searchUserData : searchUserData)
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.894, alignment: .center)
                }
            }
        }
    }
}

