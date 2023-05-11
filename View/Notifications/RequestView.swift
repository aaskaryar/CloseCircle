//
//  requestView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 6/21/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct RequestView: View {
    
    var request : Request
    var url : String
    var username : String
    //var description : String
    var myRequest : Bool
    let length = UIScreen.main.bounds.width * 0.0869
    let fontSize = UIScreen.main.bounds.width * (14 / 345)
    let smallerFontSize = UIScreen.main.bounds.width * (10 / 345)
    
    @EnvironmentObject var requestData: RequestViewModel

    
    init(request: Request){
        self.request = request
        let myuid = auth.currentUser!.uid
        myRequest = request.from_uid == myuid
        url = myRequest ? request.to_url : request.from_url
        username = myRequest ? request.to_username : request.from_username
    }
    
//    init(request: Request, to_uid: uid){
//
//    }
    
    var body: some View {
        
        HStack{
            
            EquatableWebImage(url: url, size: length, shape: Circle())
                .equatable()
                .padding(.leading)
                .padding(.trailing, 5)
            
            VStack(alignment: .leading, spacing: 2){
                
                Text(username)
                    .font(Font.custom("DM Sans", size: fontSize))
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                
                HStack{
                    
                    Text("requests to follow " + request.hobby)
                        .font(Font.custom("DM Sans", size: smallerFontSize))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .opacity(0.56)
                    
                    
                    HobbyPic(frame: 13, hobby: request.hobby, backgroundColor: Constants.ShadeGreen, foregroundColor: .white)
                    
                }
            }
            
            Spacer()
            
            ZStack{
                
                HStack{
                    
                    Button(action: {
                        requestData.accpetRequest(request: request)
                        request.status = Constants.accept
                    }){
                        
                        Text("accept")
                            .font(Font.custom("DM Sans", size: smallerFontSize))
                            .fontWeight(.bold)
                            .modifier(FitButtonModifier(cornerRadius: 6, backgroundColor: Constants.ShadeGreen, foregroundColor: .white))
                        
                    }
                    //.padding()
                    
                    Button(action: {
                        requestData.refuseRequest(request: request)
                        request.status = Constants.refused
                    }){
                        
                        Text("decline")
                            .font(Font.custom("DM Sans", size: smallerFontSize))
                            .fontWeight(.bold)
                            .modifier(FitButtonModifier(cornerRadius: 6, backgroundColor: .white, foregroundColor: Constants.ShadeGreen))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(.red, lineWidth: 1)
                            )
                    }
                    .padding(.trailing)
                }.opacity(myRequest ? 0 : (request.status == Constants.pending ? 1 : 0))
                
                Text(request.status)
                    .font(Font.custom("DM Sans", size: fontSize))
                    .padding(.trailing)
                    .opacity(myRequest ? 1 : (request.status == Constants.pending ? 0 : 1))
                
            }
            
//                            else{
//                                Text(request.status)
//                                    .padding(.trailing)
//                            }
        }
                
    }
}

//struct RequestView_Previews: PreviewProvider {
//    static var previews: some View {
//        RequestViewPreviewView()
//    }
//}
//
//struct RequestViewPreviewView: View {
//    @StateObject var requestData : RequestViewModel = RequestViewModel(uid: "pcFsbKTyQXg1lZB53ZSAiS6ZCfF3")
//
//    var body: some View{
//        RequestView(request: Request(id: "123", to_uid: "345", from_uid: "123", from_username: "abc", from_url: "", hobby: "asds", hobby_id: "sad", time: Date(), status: "Pending"))
//            .environmentObject(requestData)
//    }
//}
