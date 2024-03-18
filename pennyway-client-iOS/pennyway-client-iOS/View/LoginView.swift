

import SwiftUI

struct LoginView: View {
    @State private var isSplashShown = true
    @State private var isSignUpScreenActive = false
    
    var body: some View {
        NavigationView(content: {
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
                NavigationLink(destination: SignUpView(), isActive: $isSignUpScreenActive) {
                    Text("회원가입")
                }
                .padding()
            }
        })
    }
}



#Preview {
    LoginView()
}
