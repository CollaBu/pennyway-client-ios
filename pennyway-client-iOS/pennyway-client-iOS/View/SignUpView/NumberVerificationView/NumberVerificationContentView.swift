
import SwiftUI

struct NumberVerificationContentView: View {
    // MARK: Internal

    var body: some View {
        VStack(alignment: .leading) {
            Text("번호인증")
                .font(.pretendard(.semibold, size: 24))
                .padding(.horizontal, 20)

            Spacer().frame(height: 32)

            PhoneNumberInputSectionView(viewModel: NumberVerificationViewModel())

            Spacer().frame(height: 21)

            NumberInputSectionView(viewModel: NumberVerificationViewModel())
        }
    }
}

#Preview {
    NumberVerificationContentView()
}
