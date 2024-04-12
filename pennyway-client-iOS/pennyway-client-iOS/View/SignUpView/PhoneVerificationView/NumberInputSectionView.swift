import SwiftUI

struct NumberInputSectionView: View {
    @ObservedObject var viewModel: PhoneVerificationViewModel

    var timerString: String {
        let minutes = viewModel.timerSeconds / 60
        let seconds = viewModel.timerSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            Text("인증 번호")
                .padding(.horizontal, 20)
                .font(.pretendard(.regular, size: 12))
                .platformTextColor(color: Color("Gray04"))

            HStack(spacing: 11) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 46)
                    HStack {
                        TextField("", text: $viewModel.verificationCode)
                            .padding(.leading, 13)
                            .font(.pretendard(.medium, size: 14))
                            .keyboardType(.numberPad)
                            .onChange(of: viewModel.verificationCode) { newValue in
                                if Int(newValue) != nil {
                                    viewModel.verificationCode = String(newValue)
                                } else {
                                    viewModel.verificationCode = ""
                                }
                                viewModel.validateForm()
                            }
                        Spacer()
                        if !viewModel.isTimerHidden {
                            Text(timerString)
                                .padding(.trailing, 13)
                                .font(.pretendard(.regular, size: 12))
                                .platformTextColor(color: Color("Mint03"))
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    NumberInputSectionView(viewModel: PhoneVerificationViewModel())
}
