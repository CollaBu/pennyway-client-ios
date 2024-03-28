import SwiftUI

struct LoginView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var isSplashShown = true
    @StateObject var viewModel = LoginFormViewModel()

    
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
                    ZStack() {
                        LoginFormView(viewModel: LoginFormViewModel())
                    }
                    
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
