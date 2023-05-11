import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseAnalytics
import FirebaseDatabase

class RegistrationViewModel: ObservableObject {
    let ref = Firestore.firestore()
    // Loading View...
    @Published var success = 1
    @Published var userNumber = 1
    @Published var firstTime = 1 // change this functionality
    @Published var isLoading = false
    @Published var name = ""
    @Published var bio = ""
    @Published var isInitializing = true
    //@Published var present
    var serveruser = ""
    @AppStorage("current_status") var status = false
    // new code above
    public let database = Database.database().reference()
    let auth = Auth.auth()
    @Published var signedIn = false
    var userInfo = UserModel.emptyUserModel
    
    
    private func CheckisSignedIn(){
        if(auth.currentUser != nil){
            fetchUser(uid: auth.currentUser!.uid){ (user) in
                self.userInfo = user
                self.signedIn = true
                self.isInitializing = false
            }
        }else{
            isInitializing = false
        }
    }
    
    init(){
        CheckisSignedIn()
    }
    
    
    private var authUser : User? {
        return Auth.auth().currentUser
    }
    public func getCurrUser() ->String
    {
        return "OKOKO"
    }
    public func getCurrUserId() -> String{
        return auth.currentUser!.uid
    }
    public var currUser = ""
    public func sendVerficationEmail(){
        if self.authUser != nil && !self.authUser!.isEmailVerified {
               self.authUser!.sendEmailVerification(completion: { (error) in
                   // Notify the user that the mail has sent or couldn't because of an error.
                   
               })
           }
           else {
               // Either the user is not available, or the user is already verified.
           }
               
    }
    func setUserNumber()
    {
        let docRef = ref.collection("MetaData").document("UserMetaData")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let user_count = document.data()?["user_count"]
                self.userNumber = user_count as! Int
                self.ref.collection("MetaData").document("UserMetaData").setData([
                    "user_count": self.userNumber+1
                ])
            } else {
                
            }
        }
    }
    func signIn(username:String, password:String) 
    {
        if(!username.contains("@")) // username not email
        {
            let docRef = ref.collection("Users").document(username)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                } else {
                    self.alertView(message: "No Account Found")
                }
            }
            ref.collection("Users").whereField("username", isEqualTo: username)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        return
                    } else {
                        for document in querySnapshot!.documents {
                                        //print("\(document.documentID) => \(document.data())")
                                    
                        let user = document
                        let email = user.data()["email"] as! String
                        self.auth.signIn(withEmail: email, password: password){
                        [weak self ]result,error in
                            if error != nil {
                                    self?.alertView(message: "invalid username/email or password")
                            }
                        guard result != nil, error == nil else {
                            return
                        }
                            fetchUser(uid: Auth.auth().currentUser!.uid){ (user) in
                                self?.userInfo = user
                                self?.success = 1
                                self?.signedIn = true
                                self?.serveruser = username
                            }
                      }
                        }
                    }
                }
            }
        else
        {
            self.auth.signIn(withEmail: username, password: password){
                [weak self ]result,error in
                    if error != nil {
                            self?.alertView(message: "invalid username/email or password")
                    }
                guard result != nil, error == nil else {
                    return
                }
                
                fetchUser(uid: Auth.auth().currentUser!.uid){ (user) in
                    self?.userInfo = user
                    self?.success = 1
                    self?.signedIn = true
                    self?.serveruser = username
                }
            }
        }
    }
    
    
    func signUp(email:String, password:String, username: String)
    {
        self.firstTime = 0
        self.auth.createUser(withEmail: email, password: password)
        {
            
            [weak self ] result,error in
            if let err = error as NSError? {
                let errCode = AuthErrorCode(_nsError: err)
                switch errCode.code {
                case .invalidEmail:
                    self?.alertView(message: "invalid email")
                case .emailAlreadyInUse:
                    self?.alertView(message: "email already in use")
                case .weakPassword:
                    self?.alertView(message: "Weak Password, should be at least 6 characters")
                default:
                    self?.alertView(message: "Create User Error: \(error!)")
                }
                
            }else{
                guard result != nil else{
                    return
                }
                
                let uid = Auth.auth().currentUser!.uid
                self?.ref.collection("Users").document(uid).setData([
                
                    "uid": uid,
                    "imageurl": "https://firebasestorage.googleapis.com:443/v0/b/shade-inc.appspot.com/o/profile_Photos%2F5vOGQm3PzSTHg5mFf7bWzZwOpl12?alt=media&token=f4a7c394-8c2b-47cf-b9af-949d561ac619",
                    "username": username,
                    "email":email,
                    "bio": "A few words about yourself",
                    "following": [String: [String]](),
                    "dateCreated": Date(),
                    "follower": 0,
                    "posts": 0,
                    "following": 0,
                    "real_name": ""
                    
                ]) { (err) in
                 
                    if err != nil{
                        self?.isLoading = false
                        return
                    }
                    //print("getcalled")
                    self?.isLoading = false
                    // success means settings status as true...
                    self?.signedIn = true
                    self?.status = true
                    self?.serveruser = username
                }
                
                DispatchQueue.main.async {
                    //print("signed In turen to true")
                    self?.signedIn = true
                    self?.currUser = username
                }
                self?.setUserNumber()
                self?.sendVerficationEmail()
                
            }
            
        }
        
       
        
    }
    func signOut()
    {
        //print("called")
        try? auth.signOut()
        self.signedIn = false
    }
    
//    func alertView(message: String, completion: @escaping(String)-> ())
    func alertView(message: String)
    {
        let alert = UIAlertController(title:"Error", message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Ok",style: .default))
        /*alert.addAction(UIAlertAction(title:"Ok",style: .default,
                                      handler:{
            (_) in completion(alert.textFields![0].text ?? "")
        }))
         */
        UIApplication.shared.windows.first?.rootViewController?.present(alert,animated: true)
    }
}
