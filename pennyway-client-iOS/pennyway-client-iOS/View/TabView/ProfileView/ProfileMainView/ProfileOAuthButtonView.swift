
import SwiftUI

struct ProfileOAuthButtonView: View {
    @StateObject var kakaoOAuthViewModel: KakaoOAuthViewModel = KakaoOAuthViewModel()
    @StateObject var googleOAuthViewModel: GoogleOAuthViewModel = GoogleOAuthViewModel()
    @StateObject var appleOAuthViewModel: AppleOAuthViewModel = AppleOAuthViewModel()

    @EnvironmentObject var authViewModel: AppViewModel

    private var existKakaoOAuthAccount: Bool = getUserData()?.oauthAccount.kakao ?? false
    private var existGoogleOAuthAccount: Bool = getUserData()?.oauthAccount.google ?? false
    private var existAppleOAuthAccount: Bool = getUserData()?.oauthAccount.apple ?? false

    var body: some View {
        VStack(alignment: .center) {
            Spacer().frame(height: 24 * DynamicSizeFactor.factor())

            Text("SNS 연동 현황 확인하기")
                .font(.B2MediumFont())
                .platformTextColor(color: Color("Gray04"))

            Spacer().frame(height: 16 * DynamicSizeFactor.factor())

            OAuthButtonView(
                isKakaoLoggedIn: existKakaoOAuthAccount,
                isGoogleLoggedIn: existGoogleOAuthAccount,
                isAppleLoggedIn: existAppleOAuthAccount,

                kakaoAction: { // Kakao 로그인 액션 처리
                    kakaoOAuthViewModel.isLoggedIn = authViewModel.isLoggedIn
                    kakaoOAuthViewModel.signIn()
                    OAuthRegistrationManager.shared.provider = Provider.kakao.rawValue
                },
                googleAction: { // Google 로그인 액션 처리
                    googleOAuthViewModel.isLoggedIn = authViewModel.isLoggedIn
                    googleOAuthViewModel.signIn()
                    OAuthRegistrationManager.shared.provider = Provider.google.rawValue
                },
                appleAction: { // Apple 로그인 액션 처리
                    appleOAuthViewModel.isLoggedIn = authViewModel.isLoggedIn
                    appleOAuthViewModel.signIn()
                    OAuthRegistrationManager.shared.provider = Provider.apple.rawValue
                }
            )

            Spacer().frame(height: 24 * DynamicSizeFactor.factor())
        }

        .frame(maxWidth: .infinity)
        .background(Color("White01"))
    }
}
