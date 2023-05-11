
import SwiftUI
import Firebase
var cardLists : [CardView] = []
struct Home2View: View {
    @State private var showingSearch = false // will be used for the search page
    @State public var showingHobbies = false
    @State private var action: Int? = 0
    @State var selectedHobbies : [String] = [String]()
    @State var hobbyToFocus : HobbyModel?
    //@State var userHobbyToFocus : UserModel?
    @State var hobbyFocusInfo : HomeHobbyInfo?
    @State var scrollHeight = CGFloat.zero
    @State var contentHeight = CGFloat.zero
    @State var scrollOffset = CGFloat.zero
    @State var UserToFocus : UserModel?
    @State var CardToFocus : CardModel?
    @State var videoToPlay : videoPlayInfo?
    //@State private var filerting : Bool = false
    @ObservedObject var searchData : SearchViewModel
    @ObservedObject var postData : PostViewModel
    @ObservedObject var newPostData : NewPostModel
    @ObservedObject var notificationData : NotificationViewModel
    @ObservedObject var hobbyData : HobbiesViewModel
    @EnvironmentObject var requestData : RequestViewModel
    @EnvironmentObject var inviteData : InviteViewModel
    //@StateObject var testing = TestingDataModel()
    
    var settingData : SettingViewModel
    
    //let uid = Auth.auth().currentUser !== nil ? Auth.auth().currentUser!.uid : "nil"
    //let uid = auth.currentUser!.uid
    let exampleColor : Color = Color(red: 91/255, green: 192/255, blue: 204/255)
    let names = Constants.names
    //@State var postToDelete : CardModel?
    //@State public var selectedHobbies: [String] = []
  
    init(postData: PostViewModel, searchData: SearchViewModel, notifData: NotificationViewModel, newPost: NewPostModel, hobbyData: HobbiesViewModel, settingData : SettingViewModel)
    {
        _postData = ObservedObject(wrappedValue:postData)
        _notificationData = ObservedObject(wrappedValue: notifData)
        _searchData = ObservedObject(wrappedValue:searchData)
        _newPostData = ObservedObject(wrappedValue: newPost)
        _hobbyData = ObservedObject(wrappedValue: hobbyData)
        self.settingData = settingData
    }

    func funct()
    {
        
        withAnimation(.easeInOut){
            showingHobbies.toggle()
        }
         
    }
  
    func funct2()
    {
       //print(selectedHobbies)
    }
  

    var body: some View {
        NavigationView{
            VStack{
                
                ZStack(alignment: .center){
                    
                    HStack{
                        
                        Spacer()
                        
                        Button(action:{
                            withAnimation(.easeInOut){
                                showingHobbies.toggle()
                            }
                        }){
                            
                            HStack{
                                
                                Text("Home")
                                    .font(Font.custom("DM Sans", size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                
                                Image(systemName: "chevron.down.circle")
                                    .rotationEffect(.radians(showingHobbies ? .pi : 0))
                            }
                        }
                        
                        Spacer()
                    }
                    
                    HStack{
                        
                        Spacer()
                        
                        
        
                        Button(action: { showingSearch.toggle()})
                        {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .padding(10)
                                .background(Color(hex: 0xE4E7EC))
                                .foregroundColor(.black)
                                .clipShape(Circle())
                        }
                        
                        
                        NavigationLink(destination: NotificationView(notificationData: notificationData, newPostData: newPostData, hobbyData: hobbyData).navigationBarHidden(true).navigationBarBackButtonHidden(true)){
                           
                            Image(systemName: "bell.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .padding(10)
                                .background(Color(hex: 0xE4E7EC))
                                .foregroundColor(.black)
                                .clipShape(Circle())
                                .overlay(
                                    HStack{
                                        Spacer(minLength: 30)
                                        VStack{
                                            
                                            let notifNums = requestData.requestsCount + inviteData.inviteCounts
                                            
                                            Text(String(notifNums))
                                                .font(Font.custom("DM Sans", size: 8))
                                                .foregroundColor(.white)
                                                .background(
                                                    Color(hex: 0xFF4D44)
                                                        .frame(width: 17, height: 17, alignment: .center)
                                                        .clipShape(Circle())
                                                )
                                                .opacity(notifNums == 0 ? 0 : 1)
                                            
                                            Spacer(minLength: 30)
                                        }
                                    }
                               )
                        }
                        .padding(.trailing)
                            
                    }
                    
                }

                if(showingHobbies){
                    ScrollView(.horizontal,showsIndicators: false){
                        
                        HStack{
                            
                            ForEach(postData.hobbyList, id: \.self) { hobbyName in
                                
                                var onFocus : Bool = selectedHobbies.contains(hobbyName)
                                
                                VStack{
                                    Button(action:{
                                        
                                        if(!onFocus){
                                            selectedHobbies.append(hobbyName)
                                            
                                            
                                        }
                                        else{
                                            selectedHobbies = selectedHobbies.filter{$0 != hobbyName}
                                        }
                                        
                                        print("onFocus ", selectedHobbies)
                                        onFocus.toggle()
                                    })
                                    {
                                        HobbyPic(frame: 40, hobby: hobbyName, backgroundColor: onFocus ? Constants.ShadeGreen : Constants.ShadeGray, foregroundColor: onFocus ? .white : .black)
                                    }
                                    Text(hobbyName)
                                        .foregroundColor(.black)
                                        .font(Font.custom("DM Sans", size: 12))

                                }
                            }
                        }
                        .padding([.top, .leading, .trailing],5)
                        .frame(height: 75)
                    }
                    .padding([.top, .trailing],5)
                    .padding(.leading,10)
                    .frame(height: 75)
               }
                
                Divider()
                
                if(postData.cards.count == 0){
                    Text("No Posts")
                }
                
                GeometryReader{ scrollProxy in
                    
                    ScrollView{
                        
                        PullToRefresh(coordinateSpaceName: "homePosts") {

                            postData.getOldPosts(size: 10)

                        }
//
                        VStack(spacing: 1){
                            
                            //ScrollViewReader{ proxy in
                                
                                ForEach(postData.cards) { card in
                                    
                                    CardView(postData: postData, card: card, hobby: $hobbyToFocus, userToFocus: $UserToFocus, cardToFocus: $CardToFocus, videoToPlay: $videoToPlay)
                                        .equatable()
                                        .opacity(selectedHobbies.contains(card.hobby) || selectedHobbies.isEmpty ? 1 : 0)
                                        .frame(height: selectedHobbies.contains(card.hobby) || selectedHobbies.isEmpty ? Constants.width * 0.84 + 120: 0, alignment: .top)
                                        
                                }
                            //}
                            
                        }
                        .background(

                            Group{
                                GeometryReader {
                                    Color.clear.preference(key: ContentHeightKey.self,
                                                           value: $0.size.height)

                                }
                                GeometryReader {
                                    Color.clear.preference(key: ViewOffsetKey.self,
                                        value: -$0.frame(in: .named("homePosts")).origin.y)
                                }
                            }

                        )
                        .onAppear(){
                            scrollHeight = scrollProxy.size.height
                            print("HomeScrollHeight: \(scrollHeight)")
                        }
                        //.padding([.leading,.trailing,.top])
                        
//                        PullUpToRefresh(coordinateSpaceName: "homePosts", scrollHeight: scrollHeight){
//                            postData.getOldPosts(size: 10)
//                        }
                        
                        if scrollProxy.size.height < contentHeight{
                            
                            PullUpToRefresh(coordinateSpaceName: "homePosts", scrollHeight: scrollProxy.size.height){
                                postData.getOldPosts(size: 10)
                            }
                        }
                    
                    }
                    .coordinateSpace(name: "homePosts")
                    
                    .onPreferenceChange(ContentHeightKey.self) {
                        
                        print ("contentHeight >> \($0)")
                        contentHeight = $0
                        
                    }
                    .onPreferenceChange(ViewOffsetKey.self) {
                        // print ("offset >> \($0)")
                        scrollOffset = $0
                    }
                }    
            }
            .background(Color.white)
            .fullScreenCover(isPresented: $showingSearch) {
                SearchView(searchData: searchData, postData: postData)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onChange(of: hobbyToFocus, perform: { hobby in
                print(hobby)
                if let hobby = hobby{
                    fetchUser(uid: hobby.uid) { user in
                        if let user = user{
                            self.hobbyFocusInfo = HomeHobbyInfo(userInfo: user, hobby: hobby)
//                            self.hobbyOnDetailViewModel = HobbiesViewModel(userInfo: user)
//                            self.hobbyOnDetailViewModel?.hobbyOnDetail = hobby
//                            self.action = 1
                            self.hobbyToFocus = nil
                        }
                    }
                }
            })
            .fullScreenCover(item : $CardToFocus) { card in
                HomePostDetailView(card: card)
            }
            .fullScreenCover(item: $videoToPlay) { info in
                HomePostDisplayer(uid: info.uid, pid: info.pid)
            }
            .fullScreenCover(item : $UserToFocus) { user in
                SearchSettingsView(userInfo: user)
            }
        }
    }
}

struct HomeHobbyInfo : Identifiable{
    var id = UUID()
    var userInfo : UserModel
    var hobby : HobbyModel
}

struct videoPlayInfo : Identifiable{
    var id = UUID()
    var uid : String
    var pid : String
}
