
import SwiftUI

struct LoginOAuthButtonView: View {
    @StateObject var kakaoOAuthViewModel: KakaoOAuthViewModel = KakaoOAuthViewModel()
    @StateObject var googleOAuthViewModel: GoogleOAuthViewModel = GoogleOAuthViewModel()
    @StateObject var appleOAuthViewModel: AppleOAuthViewModel = AppleOAuthViewModel()

    @EnvironmentObject var authViewModel: AppViewModel
    @State private var isLoginSuccessful = false
    @State private var isActiveLink = false

    var body: some View {
        VStack(alignment: .center, spacing: 15 * DynamicSizeFactor.factor()) {
            OAuthButtonView(
                isKakaoLoggedIn: true,
                isGoogleLoggedIn: true,
                isAppleLoggedIn: true,

                kakaoAction: { // Kakao 로그인 액션 처리
                    kakaoOAuthViewModel.signIn()
                    OAuthRegistrationManager.shared.provider = Provider.kakao.rawValue
                },
                googleAction: { // Google 로그인 액션 처리
                    googleOAuthViewModel.signIn()
                    OAuthRegistrationManager.shared.provider = Provider.google.rawValue
                },
                appleAction: { // Apple 로그인 액션 처리
                    appleOAuthViewModel.signIn()
                    OAuthRegistrationManager.shared.provider = Provider.apple.rawValue
                }
            )
            .onReceive(kakaoOAuthViewModel.$isOAuthExistUser) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isActiveLink = !newValue
                    isLoginSuccessful = kakaoOAuthViewModel.isLoginSuccessful
                    handleOAuthLogin()
                }
            }
            .onReceive(googleOAuthViewModel.$isOAuthExistUser) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isActiveLink = !newValue
                    isLoginSuccessful = googleOAuthViewModel.isLoginSuccessful
                    handleOAuthLogin()
                }
            }
            .onReceive(appleOAuthViewModel.$isOAuthExistUser) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isActiveLink = !newValue
                    isLoginSuccessful = appleOAuthViewModel.isLoginSuccessful
                    handleOAuthLogin()
                }
            }
            NavigationLink(destination: PhoneVerificationView(), isActive: $isActiveLink) {
                EmptyView()
            }
        }
        .padding(.top, 14 * DynamicSizeFactor.factor())
    }

    func handleOAuthLogin() {
        if isLoginSuccessful {
            authViewModel.login()
        }
    }
}

// #Preview {
//    OAuthButtonView(kakaoAction: {}, googleAction: {}, appleAction: {})
// }
