
import GoogleSignIn
import SwiftUI

class GoogleOAuthViewModel: ObservableObject {
    @Published var givenName: String = ""
    @Published var isOAuthExistUser: Bool = true
    @Published var errorMessage: String = ""
    
    var oauthID = ""
    var token = ""
    
    func checkUserInfo() {
        if GIDSignIn.sharedInstance.currentUser != nil {
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else {
                return
            }
            let givenName = user.profile?.givenName
            oauthID = user.userID ?? ""
            self.givenName = givenName ?? ""
            token = user.idToken?.tokenString ?? ""
            
            oauthLoginAPI()
        } else {
            givenName = "Not Logged In"
        }
    }
    
    func oauthLoginAPI() {
        OAuthAlamofire.shared.oauthLogin(oauthID, token, "google") { result in
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
