
import Foundation
import Firebase
import FirebaseAuth


class MainHomeViewModel : ObservableObject {
    
    @Published var userName : String = "user"
    @Published var profilePhotoURL : URL?
    @Published var randomProfilePicture : String
    @Published var pageTagIndex = 0
    @Published var selectedTab : Int = 0
    
    
    private var authHandle : AuthStateDidChangeListenerHandle?
    
    init(){
        self.randomProfilePicture = SystemImages().getRandomProfilePicture()
        setupAuthStateListener()
    }
    
    deinit {
        if let handle = authHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func setupAuthStateListener() {
        authHandle = Auth.auth().addStateDidChangeListener{[weak self] (auth, user) in
            guard let self = self else { return }
            
            if let user = user {
                
                let fullname = user.displayName ?? "Invitado"
                let nameComponents = fullname.split(separator : " ")
                let firstName = nameComponents.first.map(String.init) ?? "Invitado"
                
                self.userName = firstName
                self.profilePhotoURL = user.photoURL
                
                if self.profilePhotoURL != nil {
                    self.randomProfilePicture = SystemImages()
                        .getRandomProfilePicture()
                }
            }else{
                self.userName = "Invitado"
                self.profilePhotoURL = nil
            }
        }
    }
}
