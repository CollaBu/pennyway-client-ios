import SwiftUI

struct FindPwContentView: View {
    @ObservedObject var phoneVerificationViewModel: PhoneVerificationViewModel
    @Binding var showingApiRequestPopUp: Bool

    var body: some View {
        VStack {
            Spacer().frame(height: 36 * DynamicSizeFactor.factor())

            FindPwPhoneVerificationView(viewModel: phoneVerificationViewModel, showingApiRequestPopUp: $showingApiRequestPopUp)

            Spacer().frame(height: 21 * DynamicSizeFactor.factor())

            CodeInputSectionView(viewModel: phoneVerificationViewModel)
        }
    }
}

#Preview {
    FindPwContentView(phoneVerificationViewModel: PhoneVerificationViewModel(), showingApiRequestPopUp: .constant(false))
}
