
import GoogleSignIn
import SwiftUI

class GoogleOAuthViewModel: ObservableObject {
    @Published var givenName: String = ""
    @Published var isOAuthExistUser: Bool = true
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false // 로그인 여부 
    
    private var existOAuthAccount: Bool = getUserData()?.oauthAccount.google ?? false
    private var oauthUserData = OAuthUserData(oauthId: "", idToken: "", nonce: "")
    let oauthAccountViewModel = OAuthAccountViewModel()
    
    func checkUserInfo() {
        if GIDSignIn.sharedInstance.currentUser != nil {
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else {
                return
            }
            let givenName = user.profile?.givenName
            oauthUserData.oauthId = user.userID ?? ""
            oauthUserData.idToken = user.idToken?.tokenString ?? ""
            self.givenName = givenName ?? ""
            
            let jwtParts = user.idToken?.tokenString.components(separatedBy: ".")
            guard jwtParts?.count == 3, let payloadData = Data(base64Encoded: jwtParts?[1] ?? "", options: .ignoreUnknownCharacters) else {
                print("Invalid JWT format")
                return
            }
            do {
                let payloadJSON = try JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any]
                oauthUserData.nonce = payloadJSON?["nonce"] as? String ?? ""
            } catch {
                print("Error decoding JSON: \(error)")
            }
            
            oauthLoginApi()
        } else {
            givenName = "Not Logged In"
        }
    }
    
    func oauthLoginApi() {
        let oauthLoginDto = OAuthLoginRequestDto(oauthId: oauthUserData.oauthId, idToken: oauthUserData.idToken, nonce: oauthUserData.nonce, provider: OAuthRegistrationManager.shared.provider)
        let oauthLoginViewModel = OAuthLoginViewModel(dto: oauthLoginDto)
        
        KeychainHelper.saveOAuthUserData(oauthUserData: oauthUserData)

        if isLoggedIn { // 로그인 한 경우
            oauthAccountViewModel.linkOAuthAccountApi { success in
                if success {
                    self.existOAuthAccount = true
                } else {
                    self.existOAuthAccount = false
                }
            }
        } else { // 로그인하지 않은 경우
            oauthLoginViewModel.oauthLoginApi { success, error in
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
    }
    
    func signIn() {
        if isLoggedIn && existOAuthAccount {
            oauthAccountViewModel.unlinkOAuthAccountApi { success in
                if success {
                    self.existOAuthAccount = false
                } else {
                    self.existOAuthAccount = true
                }
            }
            
        } else {
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
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}