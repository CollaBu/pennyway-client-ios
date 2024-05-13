import KakaoSDKAuth
import KakaoSDKUser
import SwiftUI

class KakaoOAuthViewModel: ObservableObject {
    @Published var givenName: String = ""
    @Published var isOAuthExistUser: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false // 로그인 여부
    @Published var isLoginSuccessful = false

    private var existOAuthAccount: Bool = getUserData()?.oauthAccount.kakao ?? false
    private var oauthUserData = OAuthUserData(oauthId: "", idToken: "", nonce: "")
    let oauthAccountViewModel = OAuthAccountViewModel()

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
                    self.oauthUserData.oauthId = String(user.id ?? 0)
                    self.oauthLoginApi()
                }
            }
        } else {
            // 카카오 로그인이 안 된 경우
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
                    self.isLoginSuccessful = true
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
            let randomNonce = CryptoHelper.randomNonceString()
            oauthUserData.nonce = CryptoHelper.sha256(randomNonce)

            // 카카오 로그인 실행
            UserApi.shared.loginWithKakaoAccount(prompts: [.Login], nonce: oauthUserData.nonce) { oauthToken, error in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoAccount() success.")
                    self.oauthUserData.idToken = oauthToken!.idToken ?? ""

                    // 로그인 성공 시 처리
                    self.checkUserInfo()
                }
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
