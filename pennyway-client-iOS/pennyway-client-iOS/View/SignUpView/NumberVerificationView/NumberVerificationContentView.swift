
import SwiftUI

struct NumberVerificationContentView: View {
    @ObservedObject var numberVerificationViewModel: NumberVerificationViewModel

    // MARK: Internal

    var body: some View {
        VStack(alignment: .leading) {
            Text("번호인증")
                .font(.pretendard(.semibold, size: 24))
                .padding(.horizontal, 20)

            Spacer().frame(height: 32)

            PhoneNumberInputSectionView(viewModel: numberVerificationViewModel)

            Spacer().frame(height: 21)

            NumberInputSectionView(viewModel: numberVerificationViewModel)
        }
    }
}

#Preview {
    NumberVerificationContentView(numberVerificationViewModel: NumberVerificationViewModel())
}
