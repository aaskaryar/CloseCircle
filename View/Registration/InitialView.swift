//
//  InitialView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/24/22.
//

import SwiftUI

struct InitialView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @State private var isShowingDetailView = false
    @State private var action: Int? = 0
    let ShadeTeal = Constants.ShadeTeal
    let names = ["BJJ", "painting", "rowing", "rockclimbing", "slacklining", "guitar", "chess", "baseline"]
    
    
    var body: some View {
        
      NavigationView {
          
          VStack(alignment: .leading){
              
              Spacer()
              
              HStack {
                  
                  Text("Welcome to \nCloseCircle")
                      .font(Font.custom("DMSans-Bold", size: 40))
                      //.fontWeight(.black)
                      .multilineTextAlignment(.leading)
                      //.padding(.leading, 20)
                  
                  Spacer()
              }
              .padding(.vertical)
              
              Group {
                  Text("A New Way to Showcase your ") +
                  Text("Hobbies")
                  .foregroundColor(ShadeTeal)
                  .fontWeight(.medium)
              }
              .font(Font.custom("DM Sans", size: 17))
              //.padding(.bottom)
              
              ScrollView(.horizontal, showsIndicators: false) {
                  
                  ScrollViewReader{ reader in
                      
                      HStack{
                          
                          ForEach(0 ..< names.count) { name in
                              
                              GeometryReader { geometry in
                                  Image(names[name])
                                      .resizable()
                                      .scaledToFill()
                                      .frame(width: UIScreen.main.bounds.width * (275/390), height: UIScreen.main.bounds.width * (275/390))
                                      .clipShape(RoundedRectangle(cornerRadius: 20))
                                      .padding()
                                      .rotation3DEffect(Angle(degrees: Double(geometry.frame( in: .global).minX) / -20), axis: (x: 0.0, y: 10.0, z: 0.0))
                                      .id(name)
                                      
                              }
                          }
                          .frame(width: UIScreen.main.bounds.width * (275/390), height: UIScreen.main.bounds.width * (300/390))
                      }
                      .onAppear {
                          withAnimation {
                              reader.scrollTo(1, anchor: .center)
                          }
                      }
                      
                  }
              }
              .padding(.vertical)
              
//              Image(names[0])
//                  .resizable()
//                  .scaledToFill()
//                  .frame(width: UIScreen.main.bounds.width * (275/390), height: UIScreen.main.bounds.width * (275/390))
//                  .clipShape(RoundedRectangle(cornerRadius: 20))
              
              
              NavigationLink(destination: CreateAccount().navigationBarBackButtonHidden(true).navigationBarHidden(true)) {
                  Text("Sign Up")
                      .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                      .font(Font.custom("DMSans-Bold", size: 20))
                      .foregroundColor(.white)
                      .background(ShadeTeal)
                      .cornerRadius(12)
              }
              .padding(.vertical, 20)
              .cornerRadius(12)
              
              HStack{
                  
                  Spacer()
                  
                  Text("Already Have an Account?")
                        .font(Font.custom("DM Sans", size: 12))
                        .padding(.top, 8)
                        .padding(.bottom, 1)
                        .frame(alignment: .center)
                  
                  Spacer()
              }
                
              NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true).navigationBarHidden(true)) {
                  Text("Login")
                      .frame(width: UIScreen.main.bounds.width - 40)
                      .font(Font.custom("DM Sans", size: 20))
                      .foregroundColor(ShadeTeal)
//                      .padding(.bottom, 40)
              }
              
              Spacer()
          }
          .navigationBarHidden(true)
          .navigationBarBackButtonHidden(true)
          .frame(width: UIScreen.main.bounds.width - 40)
      }
    }
}

struct initialViewPreview: PreviewProvider{
    static var previews: some View {
        previewProviderINitial()
    }
}

struct previewProviderINitial: View{
    let viewModel = RegistrationViewModel()
    
    var body: some View{
        InitialView()
            .environmentObject(viewModel)
    }
}
