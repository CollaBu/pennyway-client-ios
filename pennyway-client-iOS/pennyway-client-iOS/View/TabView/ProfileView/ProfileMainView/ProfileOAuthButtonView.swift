
import SwiftUI

struct ProfileOAuthButtonView: View {
    @ObservedObject var kakaoOAuthViewModel: KakaoOAuthViewModel
    @ObservedObject var googleOAuthViewModel: GoogleOAuthViewModel
    @ObservedObject var appleOAuthViewModel: AppleOAuthViewModel

    @Binding var showUnLinkPopUp: Bool
    @Binding var provider: String
    @EnvironmentObject var authViewModel: AppViewModel

    var body: some View {
        VStack(alignment: .center) {
            Spacer().frame(height: 24 * DynamicSizeFactor.factor())

            Text("SNS 연동 현황 확인하기")
                .font(.B2MediumFont())
                .platformTextColor(color: Color("Gray04"))

            Spacer().frame(height: 16 * DynamicSizeFactor.factor())

            OAuthButtonView(
                isKakaoLoggedIn: kakaoOAuthViewModel.existOAuthAccount,
                isGoogleLoggedIn: googleOAuthViewModel.existOAuthAccount,
                isAppleLoggedIn: appleOAuthViewModel.existOAuthAccount,

                kakaoAction: { // Kakao 로그인 액션 처리
                    kakaoOAuthViewModel.isLoggedIn = authViewModel.isLoggedIn
                    OAuthRegistrationManager.shared.provider = Provider.kakao.rawValue
                    if kakaoOAuthViewModel.existOAuthAccount {
                        showUnLinkPopUp = true
                        provider = "kakao"
                    } else {
                        kakaoOAuthViewModel.signIn()
                    }
                },
                googleAction: { // Google 로그인 액션 처리
                    googleOAuthViewModel.isLoggedIn = authViewModel.isLoggedIn
                    OAuthRegistrationManager.shared.provider = Provider.google.rawValue

                    if googleOAuthViewModel.existOAuthAccount {
                        showUnLinkPopUp = true
                        provider = "google"
                    } else {
                        googleOAuthViewModel.signIn()
                    }
                },
                appleAction: { // Apple 로그인 액션 처리
                    appleOAuthViewModel.isLoggedIn = authViewModel.isLoggedIn
                    OAuthRegistrationManager.shared.provider = Provider.apple.rawValue
                    if appleOAuthViewModel.existOAuthAccount {
                        showUnLinkPopUp = true
                        provider = "apple"
                    } else {
                        appleOAuthViewModel.signIn() // 계정 연동
                    }
                }
            )

            Spacer().frame(height: 24 * DynamicSizeFactor.factor())
        }

        .frame(maxWidth: .infinity)
        .background(Color("White01"))
    }
}
