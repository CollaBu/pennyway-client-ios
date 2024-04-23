import KakaoSDKAuth
import KakaoSDKUser
import SwiftUI

class KakaoOAuthViewModel: ObservableObject {
    @Published var givenName: String = ""
    @Published var isOAuthExistUser: Bool = true
    @Published var errorMessage: String = ""

    var oauthId = ""
    var nonce = ""

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
                    self.oauthId = String(user.id ?? 0)

                    print(self.oauthId)
                    self.oauthLoginApi()
                }
            }
        } else {
            // 카카오 로그인이 안 된 경우
            givenName = "Not Logged In"
        }
    }

    func oauthLoginApi() {
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
                }
            }
        }
    }

    func signIn() {
        let randomNonce = CryptoHelper.randomNonceString()
        nonce = CryptoHelper.sha256(randomNonce)

        // 카카오 로그인 실행
        UserApi.shared.loginWithKakaoAccount(prompts: [.Login], nonce: nonce) { oauthToken, error in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")

                KeychainHelper.saveIdToken(accessToken: oauthToken!.idToken ?? "")

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
