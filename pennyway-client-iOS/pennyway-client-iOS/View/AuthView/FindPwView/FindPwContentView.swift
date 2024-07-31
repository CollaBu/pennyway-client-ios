import SwiftUI

struct FindPwContentView: View {
    @ObservedObject var phoneVerificationViewModel: PhoneVerificationViewModel
    @Binding var showManyRequestPopUp: Bool

    var body: some View {
        VStack {
            Spacer().frame(height: 36 * DynamicSizeFactor.factor())

            FindPwPhoneVerificationView(viewModel: phoneVerificationViewModel, showManyRequestPopUp: $showManyRequestPopUp)

            Spacer().frame(height: 21 * DynamicSizeFactor.factor())

            CodeInputSectionView(viewModel: phoneVerificationViewModel)
        }
    }
}

#Preview {
    FindPwContentView(phoneVerificationViewModel: PhoneVerificationViewModel(), showManyRequestPopUp: .constant(false))
}
