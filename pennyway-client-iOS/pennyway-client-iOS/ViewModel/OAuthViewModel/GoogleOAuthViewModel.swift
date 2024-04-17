
import GoogleSignIn
import SwiftUI

class GoogleOAuthViewModel: ObservableObject {
    @Published var givenName: String = ""
    @Published var isOAuthExistUser: Bool = true
    @Published var errorMessage: String = ""
    
    var oauthId = ""
    
    func checkUserInfo() {
        if GIDSignIn.sharedInstance.currentUser != nil {
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else {
                return
            }
            let givenName = user.profile?.givenName
            oauthId = user.userID ?? ""
            self.givenName = givenName ?? ""
            KeychainHelper.saveIdToken(accessToken: user.idToken?.tokenString ?? "")
            
            oauthLoginAPI()
        } else {
            givenName = "Not Logged In"
        }
    }
    
    func oauthLoginAPI() {
        let viewModel = OAuthLoginViewModel(oauthId: oauthId, provider: OAuthRegistrationManager.shared.provider)

        viewModel.oauthLoginAPI { success, error in
            if success {
                self.isOAuthExistUser = true
            } else {
                if let error = error {
                    self.errorMessage = error
                } else {
                    self.isOAuthExistUser = false
                    OAuthRegistrationManager.shared.isOAuthRegistration = true
                }
            }
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
