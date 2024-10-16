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
                    isDisabled: !viewModel.isTimerRunning
                )
            }
            .padding(.horizontal, 20)
        }
    }

    private func handleCodeChange(_ newValue: String) {
        // 입력된 값이 숫자이며 6자리 이하일 때만 업데이트
        if Int(newValue) != nil && newValue.count <= 6 {
            viewModel.code = newValue
        } else if newValue.count > 6 {
            // 6자리를 초과한 경우, 6자리로 잘라서 업데이트
            viewModel.code = String(newValue.prefix(6))
        } else {
            // 비어있는 경우
            viewModel.code = ""
        }
        viewModel.validateForm()
    }
}

#Preview {
    CodeInputSectionView(viewModel: PhoneVerificationViewModel())
}
