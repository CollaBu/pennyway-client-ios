
import SwiftUI

struct ProfileOAuthButtonView: View {
    @StateObject var kakaoOAuthViewModel: KakaoOAuthViewModel = KakaoOAuthViewModel()
    @StateObject var googleOAuthViewModel: GoogleOAuthViewModel = GoogleOAuthViewModel()
    @StateObject var appleOAtuthViewModel: AppleOAtuthViewModel = AppleOAtuthViewModel()

    @EnvironmentObject var authViewModel: AppViewModel

    var body: some View {
        VStack(alignment: .center) {
            Spacer().frame(height: 24 * DynamicSizeFactor.factor())

            Text("SNS 연동 현황 확인하기")
                .font(.B2MediumFont())
                .platformTextColor(color: Color("Gray04"))

            Spacer().frame(height: 16 * DynamicSizeFactor.factor())

            OAuthButtonView(
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
                    appleOAtuthViewModel.isLoggedIn = authViewModel.isLoggedIn
                    appleOAtuthViewModel.signIn()
                    OAuthRegistrationManager.shared.provider = Provider.apple.rawValue
                }
            )

            Spacer().frame(height: 24 * DynamicSizeFactor.factor())
        }

        .frame(maxWidth: .infinity)
        .background(Color("White01"))
    }
}
