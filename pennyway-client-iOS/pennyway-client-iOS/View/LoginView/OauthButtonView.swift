
import SwiftUI

struct OauthButtonView: View {
    @StateObject var kakaoOAuthViewModel: KakaoOAuthViewModel = KakaoOAuthViewModel()
    @StateObject var googleOAuthViewModel: GoogleOAuthViewModel = GoogleOAuthViewModel()
    @StateObject var appleOAtuthViewModel: AppleOAtuthViewModel = AppleOAtuthViewModel()

    @State private var isOAuthExistUser = true

    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            HStack(spacing: 10) {
                Button(action: { // kakao
                    kakaoOAuthViewModel.signIn()
                }, label: {
                    Image("icon_signin_kakao")
                })

                Button(action: { // google
                    googleOAuthViewModel.signIn()
                }, label: {
                    Image("icon_signin_google")
                })

                Button(action: { // apple
                    appleOAtuthViewModel.signIn()
                }, label: {
                    Image("icon_signin_apple")
                })
            }
            .padding(.horizontal, 100)
        }
        Spacer().frame(height: 15)
        NavigationLink(destination: NumberVerificationView(), isActive: $isOAuthExistUser) {
            Text("??")
        }
        .onReceive(kakaoOAuthViewModel.$isOAuthExistUser) { newValue in
            print(isOAuthExistUser)
            isOAuthExistUser = !newValue
        }

//        .onReceive(googleOAuthViewModel.$isOAuthLoggedIn) { newValue in
//            isOAuthLoggedIn = newValue
//        }
//        .onReceive(appleOAtuthViewModel.$isOAuthLoggedIn) { newValue in
//            isOAuthLoggedIn = newValue
//        }
    }
}

#Preview {
    OauthButtonView()
}
