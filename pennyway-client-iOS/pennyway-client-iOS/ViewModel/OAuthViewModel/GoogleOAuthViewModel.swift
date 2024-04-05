
import GoogleSignIn
import SwiftUI

class GoogleOAuthViewModel: ObservableObject {
    @Published var givenName: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    
    func checkUserInfo() {
        if GIDSignIn.sharedInstance.currentUser != nil {
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else {
                return
            }
            let givenName = user.profile?.givenName
            self.givenName = givenName ?? ""
            isLoggedIn = true
        } else {
            isLoggedIn = false
            givenName = "Not Logged In"
        }
    }
    
    func signIn() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController)
        { _, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
            }
            self.checkUserInfo()
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
