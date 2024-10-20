
import SwiftUI

struct PhoneVerificationContentView: View {
    @ObservedObject var phoneVerificationViewModel: PhoneVerificationViewModel
    @Binding var showManyRequestPopUp: Bool

    // MARK: Internal

    var body: some View {
        VStack(alignment: .leading) {
            Text("번호인증")
                .font(.H1SemiboldFont())
                .padding(.horizontal, 20)

            Spacer().frame(height: 32 * DynamicSizeFactor.factor())

            PhoneNumberInputSectionView(viewModel: phoneVerificationViewModel, showManyRequestPopUp: $showManyRequestPopUp)

            Spacer().frame(height: 21 * DynamicSizeFactor.factor())

            CodeInputSectionView(viewModel: phoneVerificationViewModel)
        }
    }
}
