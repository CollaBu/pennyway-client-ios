

import SwiftUI

struct LoginView: View {
    @State private var isSplashShown = true
 
    var body: some View {
        Group {
            if isSplashShown {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isSplashShown = false
                            }
                        }
                    }
            } else {
                Button(action: {
                    
                }, label: {
                    Text("회원가입")
                })
            }
        }
    }
}


#Preview {
    LoginView()
}
