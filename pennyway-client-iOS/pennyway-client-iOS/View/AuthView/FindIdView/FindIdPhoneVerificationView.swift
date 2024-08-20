

import SwiftUI

struct FindIdPhoneVerificationView: View {
    @ObservedObject var viewModel: PhoneVerificationViewModel
    @Binding var showManyRequestPopUp: Bool
    @State private var isFindUser = true

    var body: some View {
        VStack(alignment: .leading, spacing: 11 * DynamicSizeFactor.factor()) {
            phoneNumberSection
            if viewModel.showErrorPhoneNumberFormat {
                ErrorText(message: "올바른 전화번호 형식이 아니에요", color: Color("Red03"))
            }
        }
        .analyzeEvent(AuthCheckEvents.findUsernamePhoneVerificationView)
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
            Log.debug("아이디 찾기 api 요청")
            viewModel.requestUserNameVerificationCodeApi {
                if viewModel.showErrorManyRequest {
                    showManyRequestPopUp = true
                } else {
                    viewModel.judgeTimerRunning()
                }
            }
        }
    }

    private func handleErrorApi() {
        if viewModel.showErrorManyRequest {
            showManyRequestPopUp = true
        } else {
            viewModel.judgeTimerRunning()
        }
    }

    private func isVerificationButtonEnabled() -> Bool {
        return !viewModel.isDisabledButton && viewModel.phoneNumber.count == 11 && viewModel.phoneNumber != viewModel.requestedPhoneNumber
    }
}
