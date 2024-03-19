

import SwiftUI

struct LoginView: View {
    @State private var isSplashShown = true
    
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
                    NavigationLink(destination: SignUpView()) {
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
