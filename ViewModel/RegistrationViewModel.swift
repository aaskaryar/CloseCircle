import SwiftUI
import Firebase
import FirebaseAuth
//import FirebaseAnalytics
import FirebaseDatabase
import FirebaseStorage

class RegistrationViewModel: ObservableObject {
    
    // Loading View...
    @Published var success = 1
    //@Published var firstTime = 1 // change this functionality
    @Published var isLoading = false
    @Published var tryingToLogin = false
    @Published var isInitializing = true
    var userNumber = 1
    @Published var signedIn = false
    @Published var loginStatus : loginResult?
    var rememberLogin = true
    
    @Published var usernameDuplicated : Bool = false
    @Published var emailDuplicated : Bool = false
    @Published var connectionIssue : Bool = false
    @Published var welcoming : Bool = false
    
    var userInfo = UserModel.emptyUserModel
    var authListener : AuthStateDidChangeListenerHandle?
    var activeUser: User!
    
    private func CheckSignedIn(){
        if(auth.currentUser != nil){
            
            //signOut()
            print("at beginning: \(auth.currentUser!.uid)")
            fetchUser(uid: auth.currentUser!.uid){ (user) in
                guard let user = user else {
                    self.rememberLogin = false
                    self.isInitializing = false
                    return
                }
                self.userInfo = user
                self.signedIn = true
                self.rememberLogin = true
                self.isInitializing = false
            }
        }else{
            rememberLogin = false
            isInitializing = false
        }
    }
    
    init(){
        CheckSignedIn()
        
    }
    
    
    public var authUser : User? {
        return auth.currentUser
    }
    
    public func sendVerficationEmail(){
        print ("sent!!!!!")
        if self.authUser != nil && !self.authUser!.isEmailVerified {
               self.authUser!.sendEmailVerification(completion: { (error) in
                   // Notify the user that the mail has sent or couldn't because of an error.
                   
               })
           }
           else {
               // Either the user is not available, or the user is already verified.
           }
               
    }
    
    public func resendVerificationEmail(completion: @escaping (Bool) -> ()){
        self.authUser!.sendEmailVerification(completion: { error in
            // Notify the user that the mail has sent or couldn't because of an error.
            if let error = error{
                completion(false)
                return
            }
            
            completion(true)
            
        })
    }
    
    public func checkVerfication(completion: @escaping (Bool) -> ()) {
        
        auth.currentUser?.reload(completion: { (err) in
            var success = false
            if err == nil{

                if Auth.auth().currentUser!.isEmailVerified{
                    success = true
                } else {
                    print("It aint verified yet")
                }
            } else {
                print(err?.localizedDescription)
            }
            completion(success)
        })
    }
    
    public func getUserNumber(){
        ref.collection("MetaData").document("UserMetaData").getDocument { (document, error) in
            if let document = document, document.exists {
                if let user_count = document.data()?["user_count"] as? Int{
                    self.userNumber = user_count
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func setUserNumber(){
        
        getUserNumber()
        
        ref.collection("MetaData").document("UserMetaData").updateData([
            "user_count": FieldValue.increment(Int64(1))
        ])
    }
    
    func signIn(username:String, password:String) 
    {
        tryingToLogin = true
        
        if(!username.contains("@")) // username not email
        {
            ref.collection("Users").whereField("username", isEqualTo: username)
                .getDocuments() { (querySnapshot, err) in
                    //print("What????")
                    if let err = err {
                        self.loginStatus = loginResult(result: "Login Failed", message: err.localizedDescription)
                        self.tryingToLogin = false
                    } else {
                                                
                        guard let snapshot = querySnapshot else{
                            self.loginStatus = loginResult(result: "Login Failed", message: "Wrong username/email or password")
                            self.tryingToLogin = false
                            return
                        }
                        
                        if snapshot.documents.count == 0 {
                            self.loginStatus = loginResult(result: "Login Failed", message: "Wrong username/email or password")
                            self.tryingToLogin = false
                            return
                        }
                        
                        guard snapshot.documents.count == 1 else{
                            print("Error: user sharing the same username")
                            self.tryingToLogin = false
                            return
                        }
                        
                        let email = snapshot.documents[0].data()["email"] as! String
                        self.firebaseSignIn(email: email, password: password)
                    }
                }
            }
        else
        {
            firebaseSignIn(email: username, password: password)
        }
    }
    
    
    func signUp(email:String, password:String, username: String, name: String, completion: @escaping (Bool) -> ()){
        //self.firstTime = 0
        //welcoming = true
        auth.createUser(withEmail: email, password: password){
            
            [weak self ] result,error in
            if let err = error as NSError? {
                
                print (err.localizedDescription)
                completion(false)
                
                return
                
            }else{
                
                //completion(true)
                guard result != nil else{
                    return
                }
                
                let uid = auth.currentUser!.uid
                ref.collection("Users").document(uid).setData([

                    "uid": uid,
                    "imageurl": "https://firebasestorage.googleapis.com/v0/b/shade-inc.appspot.com/o/default.jpg?alt=media&token=d70bfdc3-46ac-4744-912b-8e29e08eebdc",
                    "username": username,
                    "email":email.lowercased(),
                    "bio": "A few words about yourself",
                    "dateCreated": Date(),
                    "posts": 0,
                    "real_name": name

                ])

                ref.collection("MetaData").document("UserMetaData").getDocument { (document, error) in
                    if let document = document, document.exists {
                        if let user_count = document.data()?["user_count"] as? Int{
                            self?.userNumber = user_count
                        }
                        ref.collection("MetaData").document("UserMetaData").updateData([
                            "user_count": FieldValue.increment(Int64(1))
                        ])

                        completion(true)
                    } else {
                        print("Document does not exist")
                    }
                }
                
                
                self?.sendVerficationEmail()
                
//                self?.authListener = auth.addStateDidChangeListener({ auth, user in
//                    if let user = user{
//                        print("received")
//                        self?.activeUser = user
//                    }
//                })
                
            }
            
        }
    }
    
    func signOut(){
        print("called signout")
        try? auth.signOut()
        self.signedIn = false
        self.rememberLogin = false
    }
    
    
    func firebaseSignIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else {
                self?.loginStatus = loginResult(result: "Login Failed", message: "Wrong username/email or password")
                self?.tryingToLogin = false
                return
            }
            
            if let error = error{
                self?.loginStatus = loginResult(result: "Login Failed", message: error.localizedDescription)
                self?.tryingToLogin = false
                return
            }
            
            if let authResult = authResult{
                if !authResult.user.isEmailVerified{
                    authResult.user.sendEmailVerification(completion: { (error) in})
                    self?.signOut()
                    self?.loginStatus = loginResult(result: "Login Failed", message: "Email not verified")
                    self?.tryingToLogin = false
                    return
                }
            }
               
            fetchUser(uid: auth.currentUser!.uid){ (user) in
                guard let user = user else {return}
                let uid = auth.currentUser!.uid
                print(uid)
                self?.userInfo = user
                self?.tryingToLogin = false
                self?.signedIn = true
                self?.loginStatus = loginResult(result: "Login Successfully", message: "Yes!")
                //self?.serveruser = username
            }
        }
    }
}

func checkUsernameDuplicated(username: String, completion: @escaping (checkInternetResult) -> ()){
    ref.collection("Users").whereField("username", isEqualTo: username).getDocuments() { (querySnapshot, err) in
        if let err = err {
            print(err.localizedDescription)
            completion(checkInternetResult(connection: false, result: false))
            return
        } else {
            
            // if no snapshotfound, means no duplicate
            guard let snapshot = querySnapshot else{
                
                completion(checkInternetResult(connection: true, result: false))
                
                return
            }
            print(snapshot.documents)
            if snapshot.documents.isEmpty{
                completion(checkInternetResult(connection: true, result: true))
                return
            }
            
            completion(checkInternetResult(connection: true, result: false))
        }
    }
}

func checkEmailDuplicated(email: String, completion: @escaping (checkInternetResult) -> ()){
    let email = email.lowercased()
    ref.collection("Users").whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
        if let err = err {
            print(err.localizedDescription)
            completion(checkInternetResult(connection: false, result: false))
            return
        } else {
            
            // if no snapshotfound, means no duplicate
            guard let snapshot = querySnapshot else{
                
                completion(checkInternetResult(connection: true, result: false))
                
                return
            }
            print(snapshot.documents)
            if snapshot.documents.isEmpty{
                completion(checkInternetResult(connection: true, result: true))
                return
            }
            
            completion(checkInternetResult(connection: true, result: false))
        }
    }
}

struct loginResult: Identifiable{
    var id = UUID()
    var result: String
    var message: String
}

struct emailUsernameCheckResult: Identifiable{
    var id = UUID()
    var connection: Bool
    var email : Bool
    var username : Bool
}

struct checkInternetResult{
    var connection : Bool
    var result : Bool
}

extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}

//func iterateThroughDatabasePosts(){
//
//
//    realtime_ref.child("Posts").getData { error, snapShot in
//
//        guard error == nil else {
//            print(error!.localizedDescription)
//            return;
//        }
//        guard let snapshot = snapShot else {
//            return
//        }
//
//        let value = snapshot.value as? NSDictionary
////
//        let dictionary = value as? Dictionary<String,AnyObject>
////        for (id, cardDic) in value{
////
////            var card = cardDic as? CardModel ?? nil
////        }
//        dictionary?.forEach({ (id: String, value: AnyObject) in
//            let cardDic = value as! NSDictionary
//            let uid = cardDic["uid"] as! String
//
//            let imageRef = storage.reference(withPath: "post_Pics/\(uid)/\(id)")
//
//            imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
//                if let error = error {
//                    print(error)
//                  // Uh-oh, an error occurred!
//                } else {
//                  // Data for "images/island.jpg" is returned
//                    let compressedData = compressImage(data: data!)
//
//                    UploadImageForUid(id: id, imageData: compressedData, path: "post_Pics/previews", uid: uid) { result in
//                        if let error = result.error{
//                            print(error)
//                            return
//                        }
//
//                        guard let url = result.url else{
//                            return
//                        }
//                        realtime_ref.child("Posts").child("\(id)/perviewImage").setValue(url)
//
//                    }
//                }
//            }
//        })
//
//        //for (id, card) in dictionary{
//
//
//        //}
//    }
//}

//func iterateThroughFirestoreUsers(){
//
//    ref.collection("Users").getDocuments { snapshot, error in
//
//        guard error == nil else {
//            print(error!.localizedDescription)
//            return;
//        }
//        guard let snapshot = snapshot else {
//            return
//        }
//
//        for document in snapshot.documents {
//
//            print("\(document.documentID) => \(document.data())")
//
//            let uid = document.documentID
//            //let url = document.data()["imageurl"]
//
//            guard let array = document.data()["caseSearch"] else {continue}
//
//            let searchArray = array as! [String]
//
//            var lowerCased = [String]()
//
//            for name in searchArray{
//                lowerCased.append(name.lowercased())
//            }
//
//            ref.collection("Users").document(uid).updateData([
//                "caseSearch" : lowerCased
//            ])
//        }
//    }
//}

//func iterateThroughPrivateHobbies(){
//
//    ref.collectionGroup("Hobbies").whereField("privacy", isEqualTo: Constants.Private).getDocuments { (snapshot, error) in
//
//        if let error = error{
//            print(error.localizedDescription)
//        }
//
//        guard let snapshot = snapshot else {
//            return
//        }
//
//        for document in snapshot.documents {
//
//            print("\(document.data()["name"]) => \(document.data())")
//
//            let hid = document.documentID
//
//            let followers = document.data()["followers"] as! [String]
//            //let url = document.data()["imageurl"]
//
//            fetchHobbyPostList(hobbyId: hid) { postList in
//
//                guard let postList = postList else {
//                    print("hobbyPostList not found from db")
//                    return
//                }
//
//                for (postId, time) in postList{
//
//                    for uid in followers{
//
//                        realtime_ref.child("PostLists").child(uid).child("oldPosts").child(postId).setValue(time.timeIntervalSince1970)
//
//                        print("Give \(uid) \(postId)")
//                    }
//                }
//            }
//        }
//
//    }
//}



//func iterateThroughFirestoreUsers(){
//    realtime_ref.child("Posts").getData { error, snapShot in
//
//        guard error == nil else {
//            print(error!.localizedDescription)
//            return;
//        }
//        guard let snapshot = snapShot else {
//            return
//        }
//
//        let value = snapshot.value as? NSDictionary
////
//        let dictionary = value as? Dictionary<String,AnyObject>
////        for (id, cardDic) in value{
////
////            var card = cardDic as? CardModel ?? nil
////        }
//        dictionary?.forEach({ (id: String, value: AnyObject) in
//            let cardDic = value as! NSDictionary
//            //let uid = cardDic["uid"] as! String
//            //let isVideo = cardDic["isVideo"] as! Bool
//            let image = cardDic["image"] as! String
//
//            if !image.contains("post_Videos"){
//                realtime_ref.child("Posts/\(id)/isVideo").setValue(false)
//            }
//
//            //let imageRef = storage.reference(withPath: "post_Pics/\(uid)/\(id)")
//
////            imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
////                if let error = error {
////                    print(error)
////                  // Uh-oh, an error occurred!
////                } else {
////                  // Data for "images/island.jpg" is returned
////                    let compressedData = compressImage(data: data!)
////
////                    UploadImageForUid(id: id, imageData: compressedData, path: "post_Pics/previews", uid: uid) { result in
////                        if let error = result.error{
////                            print(error)
////                            return
////                        }
////
////                        guard let url = result.url else{
////                            return
////                        }
////                        realtime_ref.child("Posts").child("\(id)/perviewImage").setValue(url)
////
////                    }
////                }
////            }
//        })
//
//        //for (id, card) in dictionary{
//
//
//        //}
//    }
//}


struct Previews_RegistrationViewModel_LibraryContent: LibraryContentProvider {
    var views: [LibraryItem] {
        LibraryItem(/*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/)
    }
}
