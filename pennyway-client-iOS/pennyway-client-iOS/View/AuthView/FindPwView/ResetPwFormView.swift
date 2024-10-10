
import SwiftUI

struct ResetPwFormView: View {
    @ObservedObject var formViewModel: SignUpFormViewModel
    @ObservedObject var accountViewModel: UserAccountViewModel
    @State private var isPwDeleteButtonVisible: Bool = false
    @State private var isConfirmPwDeleteButtonVisible: Bool = false

    private let maxLength = 16

    var body: some View {
        VStack(alignment: .leading) {
            CustomInputView(inputText: $formViewModel.password, titleText: "비밀번호", onCommit: {
                formViewModel.validatePassword()
                isPwDeleteButtonVisible = false
            }, isSecureText: true, showDeleteButton: true,
            deleteAction: {
                formViewModel.password = ""
                formViewModel.showErrorPassword = false
                formViewModel.validatePwForm()
                isPwDeleteButtonVisible = false
            })
            .onChange(of: formViewModel.password) { newValue in
                if newValue.count > maxLength {
                    formViewModel.password = String(newValue.prefix(maxLength))
                }
                isPwDeleteButtonVisible = !newValue.isEmpty
            }

            if formViewModel.showErrorPassword {
                Spacer().frame(height: 9 * DynamicSizeFactor.factor())

                ErrorText(message: "숫자와 영문 소문자를 하나 이상 사용하여\n8~16자의 비밀번호를 만들어주세요", color: Color("Red03"))

                Spacer().frame(height: 24 * DynamicSizeFactor.factor())

            } else {
                Spacer().frame(height: 21 * DynamicSizeFactor.factor())
            }

            CustomInputView(inputText: $formViewModel.confirmPw, titleText: "비밀번호 확인", onCommit: {
                RegistrationManager.shared.password = formViewModel.confirmPw
                formViewModel.validateConfirmPw()
                isConfirmPwDeleteButtonVisible = false
            }, isSecureText: true, showDeleteButton: true,
            deleteAction: {
                formViewModel.confirmPw = ""
                formViewModel.showErrorConfirmPw = false
                formViewModel.validatePwForm()
                isConfirmPwDeleteButtonVisible = false
            })
            .onChange(of: formViewModel.confirmPw) { newValue in
                if newValue.count > maxLength {
                    formViewModel.confirmPw = String(newValue.prefix(maxLength))
                }
                isConfirmPwDeleteButtonVisible = !newValue.isEmpty
            }

            if formViewModel.showErrorConfirmPw {
                Spacer().frame(height: 9 * DynamicSizeFactor.factor())

                ErrorText(message: "비밀번호가 일치하지 않아요", color: Color("Red03"))
            }
        }
    }
}

#Preview {
    ResetPwFormView(formViewModel: SignUpFormViewModel(), accountViewModel: UserAccountViewModel())
}
