
import SwiftUI

struct OauthButtonView: View {
    @StateObject var kakaoOAuthViewModel: KakaoOAuthViewModel = KakaoOAuthViewModel()
    @StateObject var googleOAuthViewModel: GoogleOAuthViewModel = GoogleOAuthViewModel()
    @StateObject var appleOAtuthViewModel: AppleOAtuthViewModel = AppleOAtuthViewModel()

    @State private var isActiveLink = false

    var body: some View {
        VStack(alignment: .center, spacing: 15 * DynamicSizeFactor.factor()) {
            HStack(spacing: 10 * DynamicSizeFactor.factor()) {
                Button(action: { // kakao
                    kakaoOAuthViewModel.signIn()
                    OAuthRegistrationManager.shared.provider = provider.kakao.rawValue

                }, label: {
                    Image("icon_signin_kakao")
                        .frame(width: 30 * DynamicSizeFactor.factor(), height: 30 * DynamicSizeFactor.factor())
                })
                .onReceive(kakaoOAuthViewModel.$isOAuthExistUser) { newValue in

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isActiveLink = !newValue
                    }
                }

                Button(action: { // google
                    googleOAuthViewModel.signIn()
                    OAuthRegistrationManager.shared.provider = provider.google.rawValue
                }, label: {
                    Image("icon_signin_google")
                        .frame(width: 30 * DynamicSizeFactor.factor(), height: 30 * DynamicSizeFactor.factor())
                })
                .onReceive(googleOAuthViewModel.$isOAuthExistUser) { newValue in

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isActiveLink = !newValue
                    }
                }

                Button(action: { // apple
                    appleOAtuthViewModel.signIn()
                    OAuthRegistrationManager.shared.provider = provider.apple.rawValue
                }, label: {
                    Image("icon_signin_apple")
                        .frame(width: 30 * DynamicSizeFactor.factor(), height: 30 * DynamicSizeFactor.factor())
                })
                .onReceive(appleOAtuthViewModel.$isOAuthExistUser) { newValue in

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isActiveLink = !newValue
                    }
                }
            }

            NavigationLink(destination: PhoneVerificationView(), isActive: $isActiveLink) {
                EmptyView()
            }
        }
    }
}

#Preview {
    OauthButtonView()
}
