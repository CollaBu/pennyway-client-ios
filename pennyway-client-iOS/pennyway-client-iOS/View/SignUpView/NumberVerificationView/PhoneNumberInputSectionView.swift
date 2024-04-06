
import SwiftUI

struct PhoneNumberInputSectionView: View {
    @ObservedObject var viewModel: NumberVerificationViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            VStack(alignment: .leading, spacing: 13) {
                Text("휴대폰 번호")
                    .padding(.horizontal, 20)
                    .font(.pretendard(.regular, size: 12))
                    .platformTextColor(color: Color("Gray04"))
                HStack(spacing: 11) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color("Gray01"))
                            .frame(height: 46)
                        TextField("'-' 제외 입력", text: $viewModel.phoneNumber)
                            .padding(.leading, 13)
                            .font(.pretendard(.medium, size: 14))
                            .keyboardType(.numberPad)

                            .onChange(of: viewModel.phoneNumber) { newValue in
                                if Int(newValue) != nil {
                                    if newValue.count > 11 {
                                        viewModel.phoneNumber = String(newValue.prefix(11))
                                    }
                                } else {
                                    viewModel.phoneNumber = ""
                                }
                                viewModel.validateForm()
                            }
                    }
                    Button(action: {
                        viewModel.validatePhoneNumber()
                        // viewModel.requestVerificationCodeAPI()
                        viewModel.generateRandomVerificationCode()
                        viewModel.judgeTimerRunning()

                    }, label: {
                        Text("인증번호 받기")
                            .font(.pretendard(.medium, size: 13))
                            .platformTextColor(color: !viewModel.isDisabledButton && viewModel.phoneNumber.count >= 11 ? Color("White01") : Color("Gray04"))
                    })
                    .padding(.horizontal, 13)
                    .frame(height: 46)
                    .background(!viewModel.isDisabledButton && viewModel.phoneNumber.count == 11 ? Color("Gray05") : Color("Gray03"))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .disabled(viewModel.isDisabledButton)
                }
                .padding(.horizontal, 20)
            }
            if viewModel.showErrorPhoneNumberFormat {
                Text("존재하지 않는 전화번호예요")
                    .padding(.horizontal, 20)
                    .font(.pretendard(.medium, size: 12))
                    .platformTextColor(color: Color("Red03"))
            }
        }
    }
}

#Preview {
    PhoneNumberInputSectionView(viewModel: NumberVerificationViewModel())
}
