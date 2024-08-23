
import SwiftUI

struct CompleteChangePwView: View {
    @Binding var firstNaviLinkActive: Bool

    var body: some View {
        VStack {
            ScrollView {
                CustomCompleteView(
                    title: "새로운 비밀번호가\n성공적으로 설정되었어요",
                    subTitle: "메인화면으로 돌아갈게요"
                )
            }

            CustomBottomButton(action: {
                firstNaviLinkActive = false
                NavigationUtil.popToRootView()

                Log.debug("firstNaviLinkActive: \(firstNaviLinkActive)")
            }, label: "메인으로 돌아가기", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .analyzeEvent(ProfileEvents.passwordEditCompleteView)
    }
}

#Preview {
    CompleteChangePwView(firstNaviLinkActive: .constant(true))
}
