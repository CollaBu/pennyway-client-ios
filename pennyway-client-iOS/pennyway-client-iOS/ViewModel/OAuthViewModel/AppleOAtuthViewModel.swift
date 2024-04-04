
import AuthenticationServices
import SwiftUI

// MARK: - AppleOAtuthViewModel

class AppleOAtuthViewModel: NSObject, ObservableObject {
    @Published var givenName: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    
    func signIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func signOut() {
//        GIDSignIn.sharedInstance.signOut()
//        checkStatus()
    }
}

// MARK: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate

extension AppleOAtuthViewModel: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    /// Apple ID 연동 성공 시
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
             
            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let idToken = appleIDCredential.identityToken!
            let tokeStr = String(data: idToken, encoding: .utf8)
          
            print("User ID : \(userIdentifier)")
            print("User Email : \(String(describing: email))")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            print("token : \(String(describing: tokeStr!))")
             
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
