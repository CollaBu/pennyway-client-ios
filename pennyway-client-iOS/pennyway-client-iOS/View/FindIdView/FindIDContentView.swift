

import SwiftUI

struct FindIdContentView: View {
    @ObservedObject var phoneVerificationViewModel: PhoneVerificationViewModel

    var body: some View {
        VStack {
            Spacer().frame(height: 36)

            FindIdPhoneVerificationView(viewModel: phoneVerificationViewModel)

            Spacer().frame(height: 21)

            NumberInputSectionView(viewModel: phoneVerificationViewModel)
        }
    }
}

#Preview {
    FindIdContentView(phoneVerificationViewModel: PhoneVerificationViewModel())
}
