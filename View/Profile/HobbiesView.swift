//
//  HobbiesView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/12/22.
//

import SwiftUI
import SDWebImageSwiftUI
struct HobbiesView: View {
    
    @ObservedObject var hobbyData : HobbiesViewModel
    @ObservedObject var postData : PostViewModel
    @State var isRefreshing: Bool = false
    @Binding var hobbyToDelete : HobbyModel?
    @Binding var hobbyToEdit : HobbyModel?
    //@State var isEditing : Bool = false
    //@Binding var hobbyOnDetail : HobbyModel?
    let length : CGFloat = UIScreen.main.bounds.width * 0.826 / 2
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        
        let columns = [
                GridItem(.adaptive(minimum: 125))
            ]
        
        RoundedRectangle(cornerRadius: 25)
            .fill(Color.white)
            .shadow(color: .black.opacity(0.1), radius: 4)
            .overlay(
              NavigationView{
                 
                 VStack{
                    
                    HStack{
                        
                       Text("Hobbies")
                          .font(Font.custom("DM Sans", size: 20))
                          .fontWeight(.bold)
                          .lineLimit(1)
                       
                       Spacer()
                        
                        if(!hobbyData.isEditing){
                            Button(action: {
                                
                                withAnimation{
                                    hobbyData.isEditing.toggle()
                                }
                                
                            }){
                              Text("Edit hobbies")
                                 .font(Font.custom("DM Sans", size: 14))
                                 .fontWeight(.bold)
                                 .lineLimit(1)
                                 .foregroundColor(colorScheme == .dark ? .white : .black)
                                 .padding(.horizontal, 10)
                                 .padding(.vertical, 5)
                                 .background(
                                   Color(hex: 0xE4E7EC)
                                      .cornerRadius(9)
                                 )
                           }
                           .padding(.trailing, 20)
                           
                           Button(action: {hobbyData.newHobby.toggle()}) {
                               
                              Image(systemName: "plus")
                                 .foregroundColor(.white)
                                 .background(
                                   Constants.ShadeGreen
                                      .clipShape(Circle())
                                      .frame(width: 31, height: 31)
                                 )
                                 .padding(.horizontal, 5)
                           }
                        }else{
                            Button(action: {
                                withAnimation {
                                    hobbyData.isEditing.toggle()

                                }
                                
                            }){
                              Text("Return")
                                 .foregroundColor(.white)
                                 .font(Font.custom("DM Sans", size: 14))
                                 .fontWeight(.bold)
                                 .lineLimit(1)
                                 .background(
                                   Constants.ShadeGreen
                                      .frame(width: 71, height: 31, alignment: .center)
                                      .cornerRadius(9)
                                 )
                           }
                           .padding(.trailing, 20)
                        }
                       
                       
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .padding(.top, 12)
       
                    
                     VStack{
                         
                         if hobbyData.hobbies.isEmpty{
                             
                             Spacer(minLength: 0)
                             
                             if hobbyData.noHobbies{
                                 
                                 Text("No Hobbies")
                                     .padding(.vertical, 50)
                             }
                             else{
                                 
                                 ProgressView()
                             }
                             
                             Spacer(minLength: 0)
                         }
                         else{
                             
                             ScrollView{
                                 
                                 
                                 LazyVGrid(columns: columns, spacing: 10) {
                                     
                                     ForEach(hobbyData.hobbies) { hobby in
                                         
                                         HobbyBlock(hobbyId: hobby.id, hobbyData: hobbyData)
                                             .overlay(
                                                HStack{

                                                    VStack{

                                                        if(hobbyData.isEditing){

                                                            Button(action: {
                                                                
                                                                hobbyToDelete = hobby
                                                                

                                                            }){

                                                                Image(systemName: "minus.circle.fill")
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(width: 31, height: 31)
                                                                    .foregroundColor(Color(hex: 0xE4E7EC))
                                                                    .background(.black)
                                                                    .clipShape(Circle())

                                                            }
                                                        }

                                                        Spacer(minLength: length - 20)
                                                    }
                                                    
                                                    Spacer(minLength: length - 20)
                                                }
                                             )
                                             .overlay(
                                                
                                                VStack{
                                                    
                                                    HStack{
                                                        
                                                        Spacer()
                                                        
                                                        if hobbyData.isEditing{
                                                            
                                                            Button {
                                                                hobbyToEdit = hobby
                                                            } label: {
                                                                Text("Edit")
                                                                    .foregroundColor(.black)
                                                                    .font(Font.custom("DMSans-Bold", size: 14))
                                                                    .fontWeight(.bold)
                                                                    .lineLimit(1)
                                                                    .background(
                                                                      Constants.ShadeGray
                                                                         .frame(width: 70, height: 31, alignment: .center)
                                                                         .cornerRadius(9)
                                                                    )
                                                            }
                                                            .padding(.trailing)
                                                        }
                                                        
                                                       
                                                    }
                                                    .padding(35)
                                                    
                                                    Spacer()
                                                }
                                             )
                                     }
                                 }
                                 .padding(.horizontal, UIScreen.main.bounds.width * 0.058)
                                 
                             }
                         }
                     }
                    
                    
                   Spacer()
                    
                 }
                 .navigationBarHidden(true)
                 
              }
            )
        
        
//        .fullScreenCover(isPresented: $postData.newPost) {
//
//            NewPost(updateId: $postData.updateId)
//        }
    }

}

