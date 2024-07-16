
import SwiftUI

struct EditPhoneNumberView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = EditPhoneNumberViewModel()

    var timerString: String {
        let minutes = viewModel.timerSeconds / 60
        let seconds = viewModel.timerSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 11 * DynamicSizeFactor.factor()) {
                phoneNumberSection
                if viewModel.showErrorPhoneNumberFormat {
                    ErrorText(message: "올바른 전화번호 형식이 아니에요")
                }
                if viewModel.showErrorExistingUser {
                    ErrorText(message: "이미 가입된 전화번호예요")
                }
            }

            Spacer().frame(height: 21 * DynamicSizeFactor.factor())

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

            Spacer()

            CustomBottomButton(action: {}, label: "변경 완료", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        .edgesIgnoringSafeArea(.bottom)
        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .navigationBarColor(UIColor(named: "White01"), title: "아이디 변경")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("White01"))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("icon_arrow_back")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 34, height: 34)
                            .padding(5)
                    })
                    .padding(.leading, 5)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                }.offset(x: -10)
            }
        }
    }

    @ViewBuilder
    private var phoneNumberSection: some View {
        VStack(alignment: .leading, spacing: 13 * DynamicSizeFactor.factor()) {
            Text("휴대폰 번호")
                .padding(.horizontal, 20)
                .font(.B1RegularFont())
                .platformTextColor(color: Color("Gray04"))

            HStack(spacing: 11 * DynamicSizeFactor.factor()) {
                PhoneNumberInputField(phoneNumber: $viewModel.phoneNumber, onPhoneNumberChange: handlePhoneNumberChange)
                VerificationButton(isEnabled: !viewModel.isDisabledButton && viewModel.phoneNumber.count == 11, action: handleVerificationButtonTap)
            }
            .padding(.horizontal, 20)
        }
    }

    private func handlePhoneNumberChange(_ newValue: String) {
        if Int(newValue) != nil {
            if newValue.count > 11 {
                viewModel.phoneNumber = String(newValue.prefix(11))
            }
        } else {
            viewModel.phoneNumber = ""
        }
        viewModel.validateForm()
    }

    private func handleVerificationButtonTap() {
        viewModel.validatePhoneNumber()
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
    EditPhoneNumberView()
}
