

import SwiftUI

struct LoginView: View {
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
                    NavigationLink(destination: NumberVerificationView()) {
                        Text("회원가입")
                    }
                    .padding()
                }
            }
        }
    }

    // MARK: Private

    @State private var isSplashShown = true
}

#Preview {
    LoginView()
}
