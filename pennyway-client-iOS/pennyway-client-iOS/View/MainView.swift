import SwiftUI

struct MainView: View {
    // MARK: Private

    @EnvironmentObject var splashViewModel: AppViewModel

    var body: some View {
        VStack {
            if !splashViewModel.isSplashShown {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                splashViewModel.isSplashShown = true
                            }
                        }
                    }
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    MainView()
}
