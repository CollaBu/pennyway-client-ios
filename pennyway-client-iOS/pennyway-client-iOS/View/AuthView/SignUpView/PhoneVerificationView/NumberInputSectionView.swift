import SwiftUI

struct NumberInputSectionView: View {
    @ObservedObject var viewModel: PhoneVerificationViewModel

    var timerString: String {
        let minutes = viewModel.timerSeconds / 60
        let seconds = viewModel.timerSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 13 * DynamicSizeFactor.factor()) {
            Text("인증 번호")
                .padding(.horizontal, 20)
                .font(.B1RegularFont())
                .platformTextColor(color: Color("Gray04"))

            HStack(spacing: 11) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 46 * DynamicSizeFactor.factor())
                    HStack {
                        TextField("", text: $viewModel.code)
                            .padding(.leading, 13 * DynamicSizeFactor.factor())
                            .font(.H4MediumFont())
                            .keyboardType(.numberPad)
                            .onChange(of: viewModel.code) { newValue in
                                if Int(newValue) != nil {
                                    viewModel.code = String(newValue)
                                } else {
                                    viewModel.code = ""
                                }
                                viewModel.validateForm()
                            }
                            .disabled(!viewModel.isDisabledButton)
                        Spacer()
                        if !viewModel.isTimerHidden {
                            Text(timerString)
                                .padding(.trailing, 13 * DynamicSizeFactor.factor())
                                .font(.B1RegularFont())
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
