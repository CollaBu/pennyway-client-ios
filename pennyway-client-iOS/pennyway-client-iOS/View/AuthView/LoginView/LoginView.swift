import SwiftUI

struct LoginView: View {
    // MARK: Private

    @StateObject var loginFormViewModel = LoginFormViewModel()
    @State private var isSplashShown = true
    @State private var isActiveLink = false

    var body: some View {
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
                LoginFormView(loginFormViewModel: loginFormViewModel)
            }
        }
    }
}

#Preview {
    LoginView()
}
