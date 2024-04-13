import SwiftUI

struct WelcomeView: View {
    var name = OAuthRegistrationManager.shared.isOAuthRegistration ? OAuthRegistrationManager.shared.name : RegistrationManager.shared.name
    
    var body: some View {
        ZStack {
            NavigationAvailable {
                VStack {
                    Image("icon_illust_welcome")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 160)
                        .padding(.top, 71)
                        .padding(.horizontal, 80)
                        .padding(.bottom, 20)
                    
                    Text("\(name ?? "")님 환영합니다.")
                        .font(.pretendard(.semibold, size: 24))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 73)
                        .padding(.bottom, 12)
                        .onAppear {}
                    
                    Text("페니웨이와 절약을 시작해볼까요?")
                        .font(.pretendard(.medium, size: 14))
                        .platformTextColor(color: Color("Gray04"))
                    
                    Spacer()
                    
                    CustomBottomButton(action: {}, label: "확인", isFormValid: .constant(true))
                        .padding(.bottom, 34)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    WelcomeView()
}
