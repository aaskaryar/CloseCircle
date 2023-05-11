//
//  InviteView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 8/12/22.
//

import SwiftUI

struct InviteView: View {
    var invite : Invite
    var url : String
    var username : String
    //var description : String
    var myInvite : Bool
    let length = UIScreen.main.bounds.width * 0.0869
    let fontSize = UIScreen.main.bounds.width * (14 / 345)
    let smallerFontSize = UIScreen.main.bounds.width * (10 / 345)
    
    @EnvironmentObject var inviteData: InviteViewModel

    
    init(invite: Invite){
        self.invite = invite
        let myuid = auth.currentUser!.uid
        myInvite = invite.from_uid == myuid
        url = myInvite ? invite.to_url : invite.from_url
        username = myInvite ? invite.to_username : invite.from_username
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
                    
                    Text("requests to follow " + invite.hobby)
                        .font(Font.custom("DM Sans", size: smallerFontSize))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .opacity(0.56)
                    
                    
                    HobbyPic(frame: 13, hobby: invite.hobby, backgroundColor: Constants.ShadeGreen, foregroundColor: .white)
                    
                }
            }
            
            Spacer()
            
            ZStack{
                
                HStack{
                    
                    Button(action: {
                        inviteData.accpetInvites(invite: invite)
                        invite.status = Constants.accept
                    }){
                        
                        Text("accept")
                            .font(Font.custom("DM Sans", size: smallerFontSize))
                            .fontWeight(.bold)
                            .modifier(FitButtonModifier(cornerRadius: 6, backgroundColor: Constants.ShadeGreen, foregroundColor: .white))
                        
                    }
                    //.padding()
                    
                    Button(action: {
                        inviteData.refuseInvite(invite: invite)
                        invite.status = Constants.refused
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
                }.opacity(myInvite ? 0 : (invite.status == Constants.pending ? 1 : 0))
                
                Text(invite.status)
                    .font(Font.custom("DM Sans", size: fontSize))
                    .padding(.trailing)
                    .opacity(myInvite ? 1 : (invite.status == Constants.pending ? 0 : 1))
                
            }
            
//                            else{
//                                Text(request.status)
//                                    .padding(.trailing)
//                            }
        }
                
    }
}

//struct InviteView_Previews: PreviewProvider {
//    static var previews: some View {
//        InviteView()
//    }
//}
