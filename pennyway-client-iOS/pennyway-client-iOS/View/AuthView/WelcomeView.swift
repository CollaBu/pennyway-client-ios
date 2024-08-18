import SwiftUI

struct WelcomeView: View {
    let profileInfoViewModel = UserAccountViewModel()
    var name = OAuthRegistrationManager.shared.isOAuthRegistration ? OAuthRegistrationManager.shared.name : RegistrationManager.shared.name
    @State private var isnavigateToEditTargetView = false
    @State var initTargetAmount = TargetAmount(year: 0, month: 0, targetAmountDetail: AmountDetail(id: -1, amount: -1, isRead: false), totalSpending: 0, diffAmount: 0)
    @EnvironmentObject var authViewModel: AppViewModel

    var body: some View {
        VStack {
            Image("icon_illust_welcome")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 160 * DynamicSizeFactor.factor())
                .padding(.top, 71 * DynamicSizeFactor.factor())
                .padding(.horizontal, 80)
                .padding(.bottom, 20 * DynamicSizeFactor.factor())

            Text("\(name)님 환영합니다.")
                .font(.pretendard(.semibold, size: 24))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 73)
                .padding(.bottom, 12)
            Text("페니웨이와 절약을 시작해볼까요?")
                .font(.pretendard(.medium, size: 14))
                .platformTextColor(color: Color("Gray04"))

            Spacer()

            CustomBottomButton(action: {
                isnavigateToEditTargetView = true
            }, label: "확인", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .analyzeEvent(AuthEvents.welcomeView)

        NavigationLink(destination: TargetAmountSettingView(currentData: $initTargetAmount, entryPoint: .signUp), isActive: $isnavigateToEditTargetView) {}
            .hidden()
    }
}

#Preview {
    WelcomeView()
}
