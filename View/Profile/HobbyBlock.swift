//
//  HobbitView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/12/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct HobbyBlock: View {
    var hobbyId : String
    @State var editing = false
    var hobbyData : HobbiesViewModel
    //@ObservedObject var postData: PostViewModel
    let length = UIScreen.main.bounds.width * 0.826 / 2
    
    var body: some View {
        
        if let hobby = hobbyData.hobbiesDic[hobbyId]{
            VStack(spacing: 15){
                
                EquatableWebImage(url: hobby.url, size: length, shape: RoundedRectangle(cornerRadius: 20))
                .onTapGesture {
                    
                    if !hobbyData.isEditing{
                        hobbyData.detail.toggle()
                        hobbyData.hobbyOnDetail = hobby
                    }
                    
                }
                .overlay(
                    
                    VStack{
                        
                        Spacer()
                        
                        ZStack{
                            
                            VisualEffectView(effect: UIBlurEffect(style: .dark))
                                .frame(width: length, height: 42, alignment: .bottom)
                                .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                                .opacity(0.7)
                            
                            HStack{
                                
                                
                                Spacer()
                                
                                HobbyPic(frame: 20, hobby: hobby.name, backgroundColor: Constants.ShadeGray, foregroundColor: .black)
                                
                                Text(hobby.name)
                                    .font(Font.custom("DM Sans", size: 15))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                            }
                                
                        }
                            
                    }
                    
                )
            }
            .padding()
            .onChange(of: hobbyData.editing){ newValue in
                editing = newValue
            }
        }else{
            EmptyView()
        }
        
        
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = 5
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
