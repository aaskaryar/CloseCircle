//
//  SearchView.swift

//  ShadeInc
//
//  Created by Aria Askaryar on 4/20/22.

//  Testing
//

//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {

    
    //@Binding var text : String
    //@Environment(\.presentationMode) var presentationMode: Binding <PresentationMode>
    @Environment(\.dismiss) var dismiss
    @ObservedObject var searchData : SearchViewModel
    @ObservedObject var postData : PostViewModel
    
    @State private var searchText = ""
    
    var body: some View{
        NavigationView{
    
            VStack{
                
                HStack{
                    
                    SearchBar(text: $searchText.onChange(searchTextChanged))
                        .padding(.leading, 10)
                        .background(
                            Color.white
                        )
                    
                    Spacer()
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .padding(.trailing, 10)
                }
                .background(
                    Color.white
                        .frame(width: UIScreen.main.bounds.size.width)
                        .shadow(color: .gray, radius: 3, x: 0, y: 3)
                        .mask(Rectangle().padding(.bottom, -20)) /// here!
                )
                
                HStack{
                    Text(searchText == "" ? "Recent" : "Results")
                        .font(Font.custom("DM Sans", size: 18))
                        .opacity(0.7)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                List{
                    
                    
                    ForEach(searchData.recommandtion.map({$0.value}), id: \.self){ user in
                        
                        //Text(user.username)
                        SearchColumn(searchData: searchData, user: user)
                        
                    }
                    //.background(Color(hex: 0xE7E9EE))
                    
                }
                .background(.white)
                
                
                Spacer()
            }
            .navigationBarHidden(true)
            
        }
    }
    
    func searchTextChanged(to value: String) {
        searchData.search(searchText: searchText)
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

    /*
    @State private var isEditing = false
    
    @State var searchText = ""
    
    var searchResults: [String] {
            if searchText.isEmpty {
                return searchData.recommandtion_name
            } else {
                return searchData.recommandtion_name.filter { $0.contains(searchText) }
            }
        }
    
    var body: some View {
        VStack{
        
            
            NavigationView {
                List {
                    ForEach(searchResults, id: \.self) { username in
                        NavigationLink(destination: Text(username)) {
                            Text(username)
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "serach")
                .onChange(of: searchText){
                    searchData.search(searchText: searchText)
                }
                .navigationTitle("Contacts")
            }
            
            Spacer()
        }
        
    }
    */
    
    /*

    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.self) { name in
                    NavigationLink(destination: Text(name)) {
                        Text(name)
                    }
                }
            }
            .searchable(text: $searchText.onChange(searchTextChanged))
            .navigationTitle("Contacts")
        }
    }
    
    func searchTextChanged(to value: String) {
        searchData.search(searchText: searchText)
    }

    var searchResults: [String] {
        if searchText.isEmpty {
            return searchData.recommandtion_name
        } else {
            return searchData.recommandtion_name.filter { $0.contains(searchText) }
        }
    }
    
    
}
     */





struct SearchBar: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }

    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }


//     @Environment(\.dismiss) var dismiss
//     @State private var username: String = ""
//        var body: some View {
//            TextField(
//                    "User name (email address)",
//                    text: $username
//                )
//            Button("Press to dismiss") {
//                dismiss()
//            }
//            .font(.title)
//            .padding()
//            .background(Color.black)
//        }
// }

// struct SearchView_Previews: PreviewProvider {
//     static var previews: some View {
//         SearchView()
//     }

}
