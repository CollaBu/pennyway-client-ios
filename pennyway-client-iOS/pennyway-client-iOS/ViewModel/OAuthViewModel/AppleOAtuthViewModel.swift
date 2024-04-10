
import AuthenticationServices
import SwiftUI

// MARK: - AppleOAtuthViewModel

class AppleOAtuthViewModel: NSObject, ObservableObject {
    @Published var givenName: String = ""
    @Published var isOAuthExistUser: Bool = true
    @Published var errorMessage: String = ""
    
    var oauthID = ""
    var token = ""
    
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
            
            oauthID = userIdentifier
            token = String(data: idToken, encoding: .utf8) ?? ""
          
            print("User ID : \(userIdentifier)")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            //            print("token : \(String(describing: tokeStr!))")
            
            OAuthAlamofire.shared.oauthLogin(oauthID, token, "apple") { result in
                switch result {
                case let .success(data):
                    if let responseData = data {
                        do {
                            let responseJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                            if let code = responseJSON?["code"] as? String {
                                if code == "2000" {
                                    if let userData = responseJSON?["data"] as? [String: Any],
                                       let user = userData["user"] as? [String: Any],
                                       let userID = user["id"] as? Int
                                    {
                                        if userID != -1 {
                                            self.isOAuthExistUser = true
                                        } else {
                                            self.isOAuthExistUser = false
                                            OAuthRegistrationManager.shared.isOAuthRegistration = true
                                        }
                                    }
                                    
                                } else if code == "4000" {
                                    // 에러
                                }
                            }
                            print(responseJSON)
                        } catch {
                            print("Error parsing response JSON: \(error)")
                        }
                    }
                case let .failure(error):
                    
                    print("Failed to oauthLogin: \(error)")
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
