

import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser
import SwiftUI

struct LoginView: View {
    // MARK: Private

    @StateObject var kakaoOAuthViewModel: KakaoOAuthViewModel = KakaoOAuthViewModel()
    @StateObject var googleOAuthViewModel: GoogleOAuthViewModel = GoogleOAuthViewModel()
    @State private var isSplashShown = true

    // MARK: Internal

    var body: some View {
        NavigationAvailable {
            VStack {
                if isSplashShown {
                    SplashView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation {
                                    isSplashShown = false
                                }
                            }
                        }
                } else {
                    Button(action: {
                        kakaoOAuthViewModel.signIn()

                    }) {
                        Text("카카오 로그인")
                    }
                    Button(action: {
                        googleOAuthViewModel.signIn()

                    }) {
                        Text("구글 로그인")
                    }

                    NavigationLink(destination: NumberVerificationView()) {
                        Text("회원가입")
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
