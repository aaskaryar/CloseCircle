//
//  BugReportView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 5/1/22.
//

import SwiftUI

struct BugReportView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var settingsData : SettingViewModel
    @State var bug = ""
    
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
                
                Text("Report a Bug!")
                    .font(Font.custom("DM Sans", size: 20))
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {settingsData.reportBug(bug: bug)}){
                    Text("report")
                        .font(Font.custom("DM Sans", size: 14))
                        .fontWeight(.bold)
                        .frame(width: 71, height: 30, alignment: .center)
                        .cornerRadius(9)
                        .foregroundColor(.white)
                        .background(
                            Constants.ShadeGreen
                                .cornerRadius(9)
                        )
                }.disabled(bug.isEmpty)
            }
            .padding()
            
            TextEditor(text: $bug)
                .frame(width: UIScreen.main.bounds.width-40)
                .cornerRadius(15)
                //.padding(.vertical,20)
                .padding(EdgeInsets(top: 0, leading: 20, bottom:0 , trailing: 0))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 1.0)
                )
            
            Spacer()
        }
        .onChange(of: settingsData.isLoading){ newValue in
            
            if(newValue == false){
                BugViewAlert(success: true, message: "Bug Reported Successfully")
            }
        }
    }
    
    
    func BugViewAlert(success: Bool, message: String)
    {
        let alert = UIAlertController(title:success ? "Success" : "Error", message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Ok",style: .default, handler: { action in
            dismiss()
        }))
        /*alert.addAction(UIAlertAction(title:"Ok",style: .default,
                                      handler:{
            (_) in completion(alert.textFields![0].text ?? "")
        }))
         */
        UIApplication.shared.windows.first?.rootViewController?.present(alert,animated: true)
    }
}

