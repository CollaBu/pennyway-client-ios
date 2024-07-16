

import SwiftUI

struct FindIdContentView: View {
    @ObservedObject var phoneVerificationViewModel: PhoneVerificationViewModel

    var body: some View {
        VStack {
            Spacer().frame(height: 36 * DynamicSizeFactor.factor())

            FindIdPhoneVerificationView(viewModel: phoneVerificationViewModel)

            Spacer().frame(height: 21 * DynamicSizeFactor.factor())

            CodeInputSectionView(viewModel: phoneVerificationViewModel)
        }
    }
}

#Preview {
    FindIdContentView(phoneVerificationViewModel: PhoneVerificationViewModel())
}
