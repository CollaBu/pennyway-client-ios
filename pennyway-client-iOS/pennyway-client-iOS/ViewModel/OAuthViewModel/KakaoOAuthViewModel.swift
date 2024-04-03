import KakaoSDKAuth
import KakaoSDKUser
import SwiftUI

class KakaoOAuthViewModel: ObservableObject {
    @Published var givenName: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    
    init() {
        check()
    }
    
    func checkStatus() {
        if AuthApi.hasToken() {
            // 카카오 로그인이 되어 있는 경우
            UserApi.shared.me { user, error in
                if let error = error {
                    print(error)
                    return
                }
                if let user = user {
                    self.givenName = user.kakaoAccount?.profile?.nickname ?? ""
                    self.isLoggedIn = true
                }
            }
        } else {
            // 카카오 로그인이 안 된 경우
            isLoggedIn = false
            givenName = "Not Logged In"
        }
    }
    
    func check() {
        checkStatus()
    }
    
    func signIn() {
        // 카카오 로그인 실행
        UserApi.shared.loginWithKakaoAccount { _, error in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")
                // 로그인 성공 시 처리
                self.checkStatus()
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
                self.checkStatus()
            }
        }
    }
}
