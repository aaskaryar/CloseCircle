//
//  EditingView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/29/22.
//

import SwiftUI

struct EditingView: View {
    
    @State private var editing_value = ""
    @StateObject var settingsData : SettingViewModel
    var name = ""
    var operation : (String) -> Void
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
                        .foregroundColor(.black)
                        .padding(.trailing, 5)
                }
                
                Text("change your " + name)
                    .font(Font.custom("DM Sans", size: 20))
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {operation(editing_value)
                    
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
                }.disabled(editing_value.isEmpty || settingsData.isLoading)
            }
            .padding()
            
            TextField("New " + name, text: $editing_value)
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
        .alert(item: $settingsData.editProfileAlertInfo, content: { info in
            Alert(title: Text(info.Title), message: Text(info.Message), dismissButton: .cancel(Text("Ok"), action:{dismiss()}))
        })
//        .onChange(of: settingsData.isLoading){ newValue in
//
//            if(newValue == false){
//                EditingViewAlert(success: true, message: "Successfully change " + name)
//            }
//        }
        
        
    }
    
//    func EditingViewAlert(success: Bool, message: String)
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
