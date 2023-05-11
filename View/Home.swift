
import SwiftUI
import Firebase

struct Home: View {
    
    //@State var selectedTab = Constants.Profile
    //var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @EnvironmentObject var viewModel:RegistrationViewModel
    
    
    // All the @StateObject will be created a new instance when initialize
    // So we just initialize one @StateObject of viewModels in Home, and
    // pass them into views as parameters
    @StateObject var settingData : SettingViewModel
    @StateObject var videoCacheData : VideoCacheModel = VideoCacheModel()
    @StateObject var postData : PostViewModel
    @StateObject var followingData : FollowingViewModel
    @StateObject var hobbyData : HobbiesViewModel
    @StateObject var followerData : FollowerViewModel
    @StateObject var searchData = SearchViewModel()
    @StateObject var notificationData : NotificationViewModel
    @StateObject var newPostData = NewPostModel()
    @StateObject var newCommentData : NewCommentModel
    @StateObject var requestData : RequestViewModel
    @StateObject var inviteData : InviteViewModel
    @State private var UserListener : ListenerRegistration?
    @State private var HobbiesListener : ListenerRegistration?
    @State private var tabSelection: TabBarItem = TabBarItem(iconName: "house", title: "Home", color: Color.teal)
    private var userInfo: UserModel
    @State var spacer : Bool? = nil
    
    init(userInfo : UserModel){
        //_postData = StateObject(wrappedValue: PostViewModel(userInfo: userInfo))
        _postData = StateObject(wrappedValue: PostViewModel(userInfo: userInfo))
        _settingData = StateObject(wrappedValue: SettingViewModel(userInfo: userInfo))
        _hobbyData = StateObject(wrappedValue: HobbiesViewModel(userInfo: userInfo))
        _followingData = StateObject(wrappedValue: FollowingViewModel(userInfo: userInfo))
        _followerData = StateObject(wrappedValue: FollowerViewModel(userInfo: userInfo))
        _notificationData = StateObject(wrappedValue: NotificationViewModel(userInfo: userInfo))
        _newCommentData = StateObject(wrappedValue: NewCommentModel(userInfo: userInfo))
        _requestData = StateObject(wrappedValue: RequestViewModel(uid: userInfo.uid))
        _inviteData = StateObject(wrappedValue: InviteViewModel(userInfo: userInfo))
        self.userInfo = userInfo
    }
    

    var body: some View {
        if (viewModel.signedIn){
            let id = userInfo.uid
            CustomTabBarContainerView(selection: $tabSelection)
            {
                Home2View(postData: postData, searchData: searchData, notifData: notificationData, newPost: newPostData, hobbyData: hobbyData, settingData: settingData)
                    .tabBarItem(tab: TabBarItem(iconName: "house", title: "Home", color: Color.teal), selection: $tabSelection)

                PostPageView(dis: $spacer)
                    .tabBarItem(tab: TabBarItem(iconName: "camera", title: "Post", color: Color.teal), selection: $tabSelection)
                
                SettingsView(settingsData: settingData, hobbyData: hobbyData, postData:postData, newPostData: newPostData, searchData: searchData)
                    .tabBarItem(tab: TabBarItem(iconName: "person", title: "Profile", color: Color.teal), selection: $tabSelection)
            }
            .environmentObject(newPostData)
            .environmentObject(videoCacheData)
            .environmentObject(requestData)
            .environmentObject(newCommentData)
            .environmentObject(followingData)
            .environmentObject(followerData)
            .environmentObject(settingData)
            .environmentObject(hobbyData)
            .environmentObject(postData)
            .environmentObject(searchData)
            .environmentObject(inviteData)
            .onAppear(){
                let id = userInfo.uid
                
                UserListener = ListenOnUserChange(uid: id){ user in
                    guard let user = user else{return}
                    print("FEEL the UserModel UPDATE")
                    settingData.updateUserInfo(userInfo: user)
                    postData.updateUserInfo(userInfo: user)
                    followingData.updateUserInfo(userInfo: user)
                    followerData.updateUserInfo(userInfo: user)
                    hobbyData.updateUserInfo(userInfo: user)
                    notificationData.updateUserInfo(userInfo: user)
                    newCommentData.updateUserInfo(userInfo: user)
                }
                
                HobbiesListener = ListenOnHobbiesChange(uid: id){ hobbies in
                    print("FEEL the Hobbies UPDATE")
                    hobbyData.updateHobbies(newHobbies: hobbies)
                    followerData.updateHobbies(newHobbies: hobbies)
                }
            }
            .onDisappear(perform: {
                UserListener!.remove()
                HobbiesListener!.remove()
            })
            .padding(.bottom, 5)
            .ignoresSafeArea()
        }
    }
            
            
            
        
//        if(viewModel.isSignedIn)
//        {
//        let exampleColor : Color = Color(red: 63/255, green: 63/255, blue: 104/255)
//        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
//
//            // Custom Tab Bar....
//            if(selectedTab == "Posts"){
//                PostView()
//            }else{
//                SettingsView()
//            }
//
//            ZStack{
//
//                PostView()
//                    .opacity(selectedTab == "Posts" ? 1 : 0)
//
//                SettingsView()
//                    .opacity(selectedTab == "Settings" ? 1 : 0)
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            //.frame(width: 14.0, height: 25.0)
//
//            //CustomTabbar(selectedTab: $selectedTab)
//                //.padding(.bottom,edges!.bottom == 0 ? 15 : 0)
//            TabView(selection: $selectedTab)
//            {
//                PostView()
//                    .onTapGesture {
//                            selectedTab = "Posts"
//                        }
//                        .tabItem {
//                            Label("Home", systemImage: "house")
//                        }
//                        .background(exampleColor)
//
//                Text("Camera in Progress")
//                        .tabItem {
//                            Label("Camera", systemImage: "camera")
//                        }
//                SettingsView()
//                    .onTapGesture {
//                            selectedTab = "Settings"
//                        }
//                        .tabItem {
//                            Label("Profile", systemImage: "person")
//                        }
//                        .background(exampleColor)
//            }
//            .background(Color.white)
//        }
//        //.background(exampleColor)
//        //.background(exampleColor.ignoresSafeArea(.all, edges: .top))
//        .ignoresSafeArea(.all, edges: .top)
//        }
//        else
//        {
//            SignInView()
//        }
   // }
    
    
}

