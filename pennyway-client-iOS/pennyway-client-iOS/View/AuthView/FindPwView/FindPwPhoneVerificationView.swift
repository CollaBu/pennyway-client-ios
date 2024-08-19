

import SwiftUI

struct FindPwPhoneVerificationView: View {
    @ObservedObject var viewModel: PhoneVerificationViewModel
    @Binding var showManyRequestPopUp: Bool

    @State private var isFindUser = true

    var body: some View {
        VStack(alignment: .leading, spacing: 11 * DynamicSizeFactor.factor()) {
            phoneNumberSection
            if viewModel.showErrorPhoneNumberFormat {
                ErrorText(message: "010, 011으로 시작하는 11자리 문자열을 입력해주세요", color: Color("Red03"))
            }
        }
        .analyzeEvent(AuthCheckEvents.findPasswordPhoneVerificationView)
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
                VerificationButton(
                    isEnabled: isVerificationButtonEnabled(),
                    action: handleVerificationButtonTap
                )
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
        if isFindUser {
            viewModel.requestPwVerificationCodeApi {
                if viewModel.showErrorManyRequest {
                    showManyRequestPopUp = true
                } else {
                    viewModel.judgeTimerRunning()
                }
            }
        }
    }

    private func isVerificationButtonEnabled() -> Bool {
        return !viewModel.isDisabledButton && viewModel.phoneNumber.count == 11 && viewModel.phoneNumber != viewModel.requestedPhoneNumber
    }
}
