import SwiftUI

struct WelcomeView: View {
    /// @ObservedObject var formViewModel: SignUpFormViewModel
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
                    
                    Text("님 환영합니다.")
                        .font(.pretendard(.semibold, size: 24))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 73)
                        .padding(.bottom, 12)
                        .onAppear {
                            // print("\(formViewModel.name)님 환영합니다.")
                            // print("\(RegistrationManager.shared.name)님 환영합니다.")
                        }
                    
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
