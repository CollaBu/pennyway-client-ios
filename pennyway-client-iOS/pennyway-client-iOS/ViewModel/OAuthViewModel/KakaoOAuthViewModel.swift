import KakaoSDKAuth
import KakaoSDKUser
import SwiftUI

class KakaoOAuthViewModel: ObservableObject {
    @Published var givenName: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""

    var token = ""
    var oauthID = ""

    func checkUserInfo() {
        if AuthApi.hasToken() {
            // 카카오 로그인이 되어 있는 경우
            UserApi.shared.me { user, error in
                if let error = error {
                    print(error)
                    return
                }
                if let user = user {
                    self.givenName = user.kakaoAccount?.profile?.nickname ?? ""
                    self.oauthID = String(user.id ?? 0)

                    print(self.oauthID)
                    print(self.token)
                    self.oauthLoginAPI()
                }
            }
        } else {
            // 카카오 로그인이 안 된 경우
            isLoggedIn = false
            givenName = "Not Logged In"
        }
    }

    func oauthLoginAPI() {
        isLoggedIn = true
        AuthAlamofire.shared.oauthLogin(oauthID, token, "kakao") { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                        if let code = responseJSON?["code"] as? String {
                            if code == "2000" {
                                self.isLoggedIn = true
                                // 성공적으로 로그인한 경우

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
        // 카카오 로그인 실행
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")
                self.token = oauthToken!.idToken ?? ""

                // 로그인 성공 시 처리
                self.checkUserInfo()
            }
        }
    }

    func signOut() {
        // 카카오 로그아웃
        UserApi.shared.logout { error in
            if let error = error {
                print(error)
            } else {
                // 로그아웃 성공 시 처리
            }
        }
    }
}
