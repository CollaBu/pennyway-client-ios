
import AuthenticationServices
import SwiftUI

// MARK: - AppleOAtuthViewModel

class AppleOAtuthViewModel: NSObject, ObservableObject {
    @Published var givenName: String = ""
    @Published var isOAuthExistUser: Bool = true
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false // 로그인 여부 
    
    var oauthUserData = OAuthUserData(oauthId: "", idToken: "", nonce: "")
    
    func signIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        let randomNonce = CryptoHelper.randomNonceString()
        oauthUserData.nonce = CryptoHelper.sha256(randomNonce)
        request.requestedScopes = [.fullName, .email]
        request.nonce = oauthUserData.nonce
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func signOut() {
        // 로그아웃
    }
}

// MARK: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate

extension AppleOAtuthViewModel: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    /// Apple ID 연동 성공 시
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
             
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let idToken = appleIDCredential.identityToken!
            
            oauthUserData.oauthId = userIdentifier
            oauthUserData.idToken = String(data: idToken, encoding: .utf8) ?? ""
          
            print("User ID : \(userIdentifier)")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            
            let oauthLoginDto = OAuthLoginRequestDto(oauthId: oauthUserData.oauthId, idToken: oauthUserData.idToken, nonce: oauthUserData.nonce, provider: OAuthRegistrationManager.shared.provider)
            let oauthLoginViewModel = OAuthLoginViewModel(dto: oauthLoginDto)
            let oauthAccountViewModel = OAuthAccountViewModel()

            if isLoggedIn { // 로그인 한 경우
                oauthAccountViewModel.linkOAuthAccountApi { success in
                    if success {
                        self.isOAuthExistUser = true
                    } else {
                        self.isOAuthExistUser = false
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
                            KeychainHelper.saveOAuthUserData(oauthUserData: self.oauthUserData)
                        }
                    }
                }
            }
            
        default:
            break
        }
    }
    
    func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("No window found")
        }
        
        return window
    }
    
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithError _: Error) {
        // Handle error.
    }
}
