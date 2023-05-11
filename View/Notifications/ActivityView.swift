//
//  ActivityView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 6/21/22.
//

import SwiftUI
import SDWebImageSwiftUI


struct ActivityView: View {
    
    var notification: NotificationModel
    let length = UIScreen.main.bounds.width * 0.0869
    let fontSize = UIScreen.main.bounds.width * (14 / 375)
    //let fontSize = CGFloat(140
    let smallerFontSize = UIScreen.main.bounds.width * (10 / 375)
    //let smallerFontSize = CGFloat(10)
    @Binding var forwardPostId : ForwardPostRequest
    
    var body: some View {
        
        HStack(alignment:.top){
            
            EquatableWebImage(url: notification.from_url ?? "", size: length, shape: Circle())
                .equatable()
                .padding(.leading,5)
                .padding(.trailing, 5)
                .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 2){
                
                Text(notification.display())
                    .font(Font.custom("DMSans-Bold", size: fontSize))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    //.frame(width: UIScreen.main.bounds.width - 100, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    
                
                Text(Date().offset(from: notification.time))
                    .font(Font.custom("DM Sans", size: fontSize - 4))
                    .foregroundColor(.gray)
                
            }
            .padding(.top, 15)
            
            Spacer()
            
            if notification.type == Constants.NOTIFICATION_Tagged{
                
                Button(action: {
                    
                    // TODO: currently disable for fixing
                    //forwardPostId = ForwardPostRequest(postId: notification.postId)
                }) {
                    Text("add to profile")
                        .font(Font.custom("DM Sans", size: fontSize))
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Constants.ShadeTeal)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.trailing)
                }
                .padding(.top, 15)
            }
            
        }
        .frame(width: UIScreen.main.bounds.width - 36)
//        .background(
//            RoundedRectangle(cornerRadius: 7)
//                .stroke(Constants.ShadeTeal, lineWidth: 2)
//        )
        
//        RoundedRectangle(cornerRadius: 7)
////            .fill(Color.white)
//            .stroke(Constants.ShadeTeal, lineWidth: 2)
            
            
            
//            .overlay(
//                RoundedRectangle(cornerRadius: 12)
//                    .stroke(Constants.ShadeTeal, lineWidth: notification.type == Constants.NOTIFICATION_Tagged ? 5 : 0)
//            )
    }
}
