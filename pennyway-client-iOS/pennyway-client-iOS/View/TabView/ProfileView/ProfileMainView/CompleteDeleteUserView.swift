
import SwiftUI

struct CompleteDeleteUserView: View {
    @EnvironmentObject var authViewModel: AppViewModel

    var body: some View {
        VStack {
            ScrollView {
                CustomCompleteView(
                    title: "탈퇴되었어요",
                    subTitle: "이용해 주셔서 감사합니다"
                )
            }

            CustomBottomButton(action: {
                authViewModel.logout()

            }, label: "메인으로 돌아가기", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }

        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .analyzeEvent(ProfileEvents.accountDeleteSuccessPopUp)
    }
}
