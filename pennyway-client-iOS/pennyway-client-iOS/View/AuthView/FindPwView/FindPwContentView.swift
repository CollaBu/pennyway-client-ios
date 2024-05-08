import SwiftUI

struct FindPwContentView: View {
    @ObservedObject var phoneVerificationViewModel: PhoneVerificationViewModel

    var body: some View {
        VStack {
            Spacer().frame(height: 36)

            FindPwPhoneVerificationView(viewModel: phoneVerificationViewModel)

            Spacer().frame(height: 21)

            NumberInputSectionView(viewModel: phoneVerificationViewModel)
        }
    }
}

#Preview {
    FindPwContentView(phoneVerificationViewModel: PhoneVerificationViewModel())
}
