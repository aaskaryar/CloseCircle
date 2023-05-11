//
//  NewCategoryView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 5/11/22.
//

import SwiftUI

struct NewCategoryView: View {
    
    @State private var editing_value = ""
    @StateObject var hobbyData : HobbiesViewModel
    var hobby : HobbyModel
    var operation : (String, String) -> Void
    @State var alertInfo : AlertInfo?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack{
            
            HStack{
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 5)
                        .foregroundColor(.black)
                }
                
                Text("Add category in " + hobby.name)
                    .font(Font.custom("DM Sans", size: 20))
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {operation(hobby.id, editing_value)
                    
                }){
                    Text("save")
                        .font(Font.custom("DM Sans", size: 14))
                        .fontWeight(.bold)
                        .frame(width: 71, height: 30, alignment: .center)
                        .cornerRadius(9)
                        .foregroundColor(.white)
                        .background(
                            Constants.ShadeGreen
                                .cornerRadius(9)
                        )
                }.disabled(editing_value.isEmpty || hobbyData.isLoading)
            }
            .padding()
            
            TextField("New category", text: $editing_value)
                .frame(width: UIScreen.main.bounds.width-40, height: 48)
                .cornerRadius(15)
                //.padding(.vertical,20)
                .padding(EdgeInsets(top: 0, leading: 20, bottom:0 , trailing: 0))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 1.0)
                )
            
            Spacer()
            
        }
        .onChange(of: hobbyData.isLoading){ newValue in
            
            if(newValue == false){
                //newCategoryAlert(success: true, message: "Successfully added new category:  " + editing_value)
                alertInfo = AlertInfo(Title: "Success", Message: "Successfully added new category: " + editing_value)
            }
        }
        .alert(item: $alertInfo) { info in
            Alert(title: Text(info.Title), message: Text(info.Message), dismissButton: .cancel(Text("Ok")){
                dismiss()
            })
        }
        
        
    }
    
//    func newCategoryAlert(success: Bool, message: String)
//    {
//        let alert = UIAlertController(title:success ? "Success" : "Error", message:message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title:"Ok",style: .default, handler: { action in
//            dismiss()
//        }))
//        /*alert.addAction(UIAlertAction(title:"Ok",style: .default,
//                                      handler:{
//            (_) in completion(alert.textFields![0].text ?? "")
//        }))
//         */
//        UIApplication.shared.windows.first?.rootViewController?.present(alert,animated: true)
//    }
    
}
