
import SwiftUI

struct OauthButtonView: View {
    @StateObject var kakaoOAuthViewModel: KakaoOAuthViewModel = KakaoOAuthViewModel()
    @StateObject var googleOAuthViewModel: GoogleOAuthViewModel = GoogleOAuthViewModel()
    @StateObject var appleOAtuthViewModel: AppleOAtuthViewModel = AppleOAtuthViewModel()

    @State private var isActiveLink = false

    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            HStack(spacing: 10) {
                Button(action: { // kakao
                    kakaoOAuthViewModel.signIn()
                    OAuthRegistrationManager.shared.provider = "kakao"

                }, label: {
                    Image("icon_signin_kakao")
                })
                .onReceive(kakaoOAuthViewModel.$isOAuthExistUser) { newValue in

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isActiveLink = !newValue
                    }
                }

                Button(action: { // google
                    googleOAuthViewModel.signIn()
                    OAuthRegistrationManager.shared.provider = "google"
                }, label: {
                    Image("icon_signin_google")
                })
                .onReceive(googleOAuthViewModel.$isOAuthExistUser) { newValue in

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isActiveLink = !newValue
                    }
                }

                Button(action: { // apple
                    appleOAtuthViewModel.signIn()
                    OAuthRegistrationManager.shared.provider = "apple"
                }, label: {
                    Image("icon_signin_apple")
                })
                .onReceive(appleOAtuthViewModel.$isOAuthExistUser) { newValue in

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isActiveLink = !newValue
                    }
                }
            }
            .padding(.horizontal, 100)

            NavigationLink(destination: PhoneVerificationView(), isActive: $isActiveLink) {
                EmptyView()
            }
        }
    }
}

#Preview {
    OauthButtonView()
}
