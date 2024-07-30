

import SwiftUI

struct FindIdContentView: View {
    @ObservedObject var phoneVerificationViewModel: PhoneVerificationViewModel
    @Binding var showingApiRequestPopUp: Bool

    var body: some View {
        VStack {
            Spacer().frame(height: 36 * DynamicSizeFactor.factor())

            FindIdPhoneVerificationView(viewModel: phoneVerificationViewModel, showingApiRequestPopUp: $showingApiRequestPopUp)

            Spacer().frame(height: 21 * DynamicSizeFactor.factor())

            CodeInputSectionView(viewModel: phoneVerificationViewModel)
        }
    }
}

#Preview {
    FindIdContentView(phoneVerificationViewModel: PhoneVerificationViewModel(), showingApiRequestPopUp: .constant(false))
}
