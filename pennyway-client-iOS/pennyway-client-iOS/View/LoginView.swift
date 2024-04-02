

import KakaoSDKAuth
import KakaoSDKUser
import SwiftUI

struct LoginView: View {
    // MARK: Private

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
                        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                            if let error = error {
                                print(error)
                            } else {
                                print("loginWithKakaoAccount() success.")

                                // do something
                                _ = oauthToken
                            }
                        }

                    }) {
                        Text("카카오 로그인")
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
