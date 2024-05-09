
import SwiftUI

struct LoginOAuthButtonView: View {
    @StateObject var kakaoOAuthViewModel: KakaoOAuthViewModel = KakaoOAuthViewModel()
    @StateObject var googleOAuthViewModel: GoogleOAuthViewModel = GoogleOAuthViewModel()
    @StateObject var appleOAtuthViewModel: AppleOAtuthViewModel = AppleOAtuthViewModel()

    @State private var isActiveLink = false

    var body: some View {
        VStack(alignment: .center, spacing: 15 * DynamicSizeFactor.factor()) {
            OAuthButtonView(
                kakaoAction: { // Kakao 로그인 액션 처리
                    kakaoOAuthViewModel.signIn()
                    OAuthRegistrationManager.shared.provider = Provider.kakao.rawValue
                },
                googleAction: { // Google 로그인 액션 처리
                    googleOAuthViewModel.signIn()
                    OAuthRegistrationManager.shared.provider = Provider.google.rawValue
                },
                appleAction: { // Apple 로그인 액션 처리
                    appleOAtuthViewModel.signIn()
                    OAuthRegistrationManager.shared.provider = Provider.apple.rawValue
                }
            )
            .onReceive(kakaoOAuthViewModel.$isOAuthExistUser) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isActiveLink = !newValue
                }
            }
            .onReceive(googleOAuthViewModel.$isOAuthExistUser) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isActiveLink = !newValue
                }
            }
            .onReceive(appleOAtuthViewModel.$isOAuthExistUser) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isActiveLink = !newValue
                }
            }
            NavigationLink(destination: PhoneVerificationView(), isActive: $isActiveLink) {
                EmptyView()
            }
        }
    }
}

#Preview {
    OAuthButtonView(kakaoAction: {}, googleAction: {}, appleAction: {})
}
