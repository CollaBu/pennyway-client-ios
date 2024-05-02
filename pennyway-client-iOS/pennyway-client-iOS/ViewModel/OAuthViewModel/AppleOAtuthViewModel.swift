
import AuthenticationServices
import SwiftUI

// MARK: - AppleOAtuthViewModel

class AppleOAtuthViewModel: NSObject, ObservableObject {
    @Published var givenName: String = ""
    @Published var isOAuthExistUser: Bool = true
    @Published var errorMessage: String = ""
    
    var oauthId = ""
    var token = ""
    var nonce = ""
    
    func signIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        let randomNonce = CryptoHelper.randomNonceString()
        nonce = CryptoHelper.sha256(randomNonce)
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce
        
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
            
            oauthId = userIdentifier
            KeychainHelper.saveIdToken(accessToken: String(data: idToken, encoding: .utf8) ?? "")
          
            print("User ID : \(userIdentifier)")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            
            let oauthLoginDto = OAuthLoginRequestDto(oauthId: oauthId, idToken: KeychainHelper.loadIdToken() ?? "", nonce: nonce, provider: OAuthRegistrationManager.shared.provider)
            let viewModel = OAuthLoginViewModel(dto: oauthLoginDto)

            viewModel.oauthLoginApi { success, error in
                if success {
                    self.isOAuthExistUser = true
                } else {
                    if let error = error {
                        self.errorMessage = error
                    } else {
                        self.isOAuthExistUser = false
                        OAuthRegistrationManager.shared.isOAuthRegistration = true
                        OAuthRegistrationManager.shared.oauthId = self.oauthId
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
