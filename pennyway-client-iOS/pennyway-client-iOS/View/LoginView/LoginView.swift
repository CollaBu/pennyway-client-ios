
import SwiftUI

struct LoginView: View {
    // MARK: Private

    @State private var isSplashShown = true
    @State private var isSplashShownn = false

    var body: some View {
        NavigationAvailable {
            VStack {
                if isSplashShown {
                    SplashView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation {
                                    isSplashShown = false
                                    isSplashShownn = true
                                }
                            }
                        }
                } else {
                    LoginFormView(viewModel: LoginFormViewModel())
                }
            }
            NavigationLink(destination: NumberVerificationView(), isActive: $isSplashShownn) {
                EmptyView()
            }
        }
    }
}

#Preview {
    LoginView()
}
