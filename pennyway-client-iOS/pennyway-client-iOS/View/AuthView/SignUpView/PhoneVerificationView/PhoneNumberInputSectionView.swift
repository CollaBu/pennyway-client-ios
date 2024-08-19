
import SwiftUI

struct PhoneNumberInputSectionView: View {
    @ObservedObject var viewModel: PhoneVerificationViewModel
    @State private var isOAuthRegistration = OAuthRegistrationManager.shared.isOAuthRegistration
    @Binding var showManyRequestPopUp: Bool
    @State private var showErrorExistingUser = false

    var body: some View {
        VStack(alignment: .leading, spacing: 11 * DynamicSizeFactor.factor()) {
            phoneNumberSection
            if viewModel.showErrorPhoneNumberFormat {
                ErrorText(message: "올바른 전화번호 형식이 아니에요", color: Color("Red03"))
            }
            if showErrorExistingUser {
                ErrorText(message: "이미 가입된 전화번호예요", color: Color("Red03"))
            }
        }
        .onChange(of: viewModel.showErrorExistingUser) { newValue in
            showErrorExistingUser = newValue
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
            if viewModel.showErrorExistingUser {
                if viewModel.phoneNumber != viewModel.requestedPhoneNumber {
                    showErrorExistingUser = false
                } else {
                    showErrorExistingUser = true
                }
            }
        } else {
            viewModel.phoneNumber = ""
        }
        viewModel.validateForm()
    }

    private func handleVerificationButtonTap() {
        if isOAuthRegistration {
            viewModel.requestOAuthVerificationCodeApi { 
                handleErrorApi()
            }
        } else {
            viewModel.requestVerificationCodeApi { 
                handleErrorApi()
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
