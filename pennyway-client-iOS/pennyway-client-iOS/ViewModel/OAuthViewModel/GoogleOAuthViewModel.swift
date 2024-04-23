
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
            
            let jwtParts = user.idToken?.tokenString.components(separatedBy: ".")
            guard jwtParts?.count == 3, let payloadData = Data(base64Encoded: jwtParts?[1] ?? "", options: .ignoreUnknownCharacters) else {
                print("Invalid JWT format")
                return
            }
            do {
                let payloadJSON = try JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any]
                let nonce = payloadJSON?["nonce"] as? String ?? ""
            } catch {
                print("Error decoding JSON: \(error)")
            }
            
            oauthLoginApi()
        } else {
            givenName = "Not Logged In"
        }
    }
    
    func oauthLoginApi() {
        let viewModel = OAuthLoginViewModel(oauthId: oauthId, provider: OAuthRegistrationManager.shared.provider)

        viewModel.oauthLoginApi { success, error in
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
