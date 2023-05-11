//
//  Welcome.swift
//  Testing
//
//  Created by Aria Askaryar on 4/22/22.
//

import SwiftUI
import Firebase
let ShadeTeal = Constants.ShadeTeal
struct WelcomeView: View {
    @State private var action: Int? = 0
    var name : String
    @EnvironmentObject var viewModel: RegistrationViewModel
    let length = UIScreen.main.bounds.width

    var body: some View {
    
        VStack {
            
            Spacer()
            
            HStack {
                
                VStack(alignment: .leading){
                    Text("Welcome")
                        .font(Font.custom("DMSans-Bold", size: length * 0.128))
                        .fontWeight(.black)
                        .padding(.leading)
                    
                    Text(name)
                        .font(Font.custom("DMSans-Bold", size: length * 0.128))
                        .fontWeight(.black)
                        .padding(.leading)

                }
                
                Spacer()

//                Image("PuzzleLogin")
            }
            .padding(.bottom, 50)
            
            HStack{
                
                Spacer()
                
                Group{
                    Text("You are the ") +
                    Text("#\(viewModel.userNumber) ").foregroundColor(Constants.ShadeTeal) +
                    Text("legend")
                }
                .font(Font.custom("DMSans-Bold", size: CGFloat(Int(length * 0.074))))
                
                Spacer()
                
            }
            
            HStack{
                Spacer()
                
                Text("to join Shades")
                    .font(Font.custom("DMSans-Bold", size: CGFloat(Int(length * 0.074))))
                
                Spacer()
            }
            
            
            
            
            Button(action: {
                fetchUser(uid: auth.currentUser!.uid) { user in
                    guard let user = user else {return}
                    viewModel.userInfo = user
                    viewModel.signedIn = true
                }
            }) {
                Text("Continue")
                    .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                    .font(Font.custom("DM Sans", size: 20))
                    .foregroundColor(.white)
                    .background(ShadeTeal)
                    .cornerRadius(12)
            }
            .padding(.top, 20)
            .cornerRadius(12)
            
            Spacer()
//
//                NavigationLink(destination: Home(userInfo: viewModel.userInfo).navigationBarBackButtonHidden(true).navigationBarHidden(true), tag: 1, selection: $action) {
//                    EmptyView()
//                  }
//                  .hidden()
            
        }
        .navigationBarHidden(true)
        .frame(width: UIScreen.main.bounds.width - 30)
      
    
    }
}
struct WelcomeView_Previews: PreviewProvider {
     static var previews: some View {
         WelcomeView(name: "John")
     }
}

