import SwiftUI

struct CodeInputSectionView: View {
    @ObservedObject var viewModel: PhoneVerificationViewModel

    var timerString: String {
        let minutes = viewModel.timerSeconds / 60
        let seconds = viewModel.timerSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 13 * DynamicSizeFactor.factor()) {
            Text("인증번호")
                .padding(.horizontal, 20)
                .font(.B1RegularFont())
                .platformTextColor(color: Color("Gray04"))

            HStack(spacing: 11 * DynamicSizeFactor.factor()) {
                CodeInputField(
                    code: $viewModel.code,
                    onCodeChange: handleCodeChange,
                    isTimerHidden: viewModel.isTimerHidden,
                    timerString: timerString,
                    isDisabled: !viewModel.isDisabledButton
                )
            }
            .padding(.horizontal, 20)
        }
    }

    private func handleCodeChange(_ newValue: String) {
        if Int(newValue) != nil {
            viewModel.code = String(newValue)
        } else {
            viewModel.code = ""
        }
        viewModel.validateForm()
    }
}

#Preview {
    CodeInputSectionView(viewModel: PhoneVerificationViewModel())
}
