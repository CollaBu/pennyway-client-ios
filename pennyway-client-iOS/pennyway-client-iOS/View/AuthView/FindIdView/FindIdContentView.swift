

import SwiftUI

struct FindIdContentView: View {
    @ObservedObject var phoneVerificationViewModel: PhoneVerificationViewModel
    @Binding var showManyRequestPopUp: Bool

    var body: some View {
        VStack {
            Spacer().frame(height: 36 * DynamicSizeFactor.factor())

            FindIdPhoneVerificationView(viewModel: phoneVerificationViewModel, showManyRequestPopUp: $showManyRequestPopUp)

            Spacer().frame(height: 21 * DynamicSizeFactor.factor())

            CodeInputSectionView(viewModel: phoneVerificationViewModel)
        }
        .analyzeEvent(AuthCheckEvents.findUsernamePhoneVerificationView)
    }
}

#Preview {
    FindIdContentView(phoneVerificationViewModel: PhoneVerificationViewModel(), showManyRequestPopUp: .constant(false))
}
