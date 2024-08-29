
import SwiftUI

struct CompleteChangePwView: View {
    @EnvironmentObject var authViewModel: AppViewModel
    let entryPoint: PasswordChangeTypeNavigation

    var body: some View {
        VStack {
            ScrollView {
                CustomCompleteView(
                    title: "새로운 비밀번호가\n성공적으로 설정되었어요",
                    subTitle: "메인화면으로 돌아갈게요"
                )
            }
            CustomBottomButton(action: {
                NavigationUtil.popToRootView()

            }, label: "메인으로 돌아가기", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .analyzeEvent(ProfileEvents.passwordEditCompleteView)
    }
}
