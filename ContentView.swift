//
//  ContentView.swift
//  ShadeInc
//
//BAOBAO
import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import SDWebImageSwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @StateObject var test : TestViewModel = TestViewModel()
    @State var isNavigationBarHidden : Bool = true

    //@State private var tabSelection: TabBarItem = TabBarItem(iconName: "house", title: "Home", color: Color.red)
    
    var body: some View {
        
//        VStack{
//
//            Button {
//                test.picker.toggle()
//            } label: {
//                Text("Yes")
//            }
//            .onChange(of: test.result.count) { _ in
//                //print("Detected")
//                test.showEditView = true
//            }
//
//        }
//        .fullScreenCover(isPresented: $test.picker) {
//
//            ImagePickerNavigation(isActive: $test.showEditView, picker: $test.picker, result: $test.result, content: AssetEditView(result: test.result).navigationBarHidden(true).navigationBarBackButtonHidden(true))
//        }
//        .environmentObject(test)
//        .sheet(item: $test.result) { result in
//
//            if let url = result.url{
//                VideoEditor(url: url)
//            }else{
//                EmptyView()
//            }
//
//        }
        //TestView()
        
        VStack{

            //Text("Hello")

            //envionmentPreviewPage()

            if(viewModel.isInitializing){
                LoadingView()
            }else{
                if viewModel.signedIn{
                    Home(userInfo: viewModel.userInfo)
//                        .onAppear {
//                            fetchPost(postId: "-N99X7jaA7fEHxwfKSjx") { card in
//                                print(card)
//                            }
//                        }
                }else{
                    InitialView()
                    //PostPageView()
                }
            }

        }
    }
}




