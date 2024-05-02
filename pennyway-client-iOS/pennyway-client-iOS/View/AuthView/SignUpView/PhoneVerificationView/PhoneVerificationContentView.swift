
import SwiftUI

struct PhoneVerificationContentView: View {
    @ObservedObject var phoneVerificationViewModel: PhoneVerificationViewModel

    // MARK: Internal

    var body: some View {
        VStack(alignment: .leading) {
            Text("번호인증")
                .font(.pretendard(.semibold, size: 24))
                .padding(.horizontal, 20)

            Spacer().frame(height: 32)

            PhoneNumberInputSectionView(viewModel: phoneVerificationViewModel) 

            Spacer().frame(height: 21)

            NumberInputSectionView(viewModel: phoneVerificationViewModel)
        }
    }
}

#Preview {
    PhoneVerificationContentView(phoneVerificationViewModel: PhoneVerificationViewModel())
}
