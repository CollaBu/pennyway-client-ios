
import SwiftUI

struct ResetPwFormView: View {
    @ObservedObject var formViewModel: SignUpFormViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 21 * DynamicSizeFactor.factor()) {
            VStack(alignment: .leading) {
                ZStack {
                    CustomInputView(inputText: $formViewModel.password, titleText: "비밀번호", onCommit: {
                        print(formViewModel.password)
                        formViewModel.validatePassword()
                        formViewModel.validatePwForm()
                    }, isSecureText: true)
                    
                    closeButton(isVisible: formViewModel.showErrorPassword && !formViewModel.password.isEmpty, action: {
                        formViewModel.password = ""
                        formViewModel.showErrorPassword = false
                    })
                }
                Spacer().frame(height: 9 * DynamicSizeFactor.factor())
                if formViewModel.showErrorPassword {
                    errorMessage("숫자와 영문 소문자를 하나 이상 사용하여\n8~16자의 비밀번호를 만들어주세요")
                }
    
                Spacer().frame(height: 21 * DynamicSizeFactor.factor())
                
                ZStack {
                    CustomInputView(inputText: $formViewModel.confirmPw, titleText: "비밀번호 확인", onCommit: {
                        formViewModel.validateConfirmPw()
                        formViewModel.validatePwForm()
                    }, isSecureText: true)
                    
                    closeButton(isVisible: formViewModel.showErrorConfirmPw && !formViewModel.confirmPw.isEmpty, action: {
                        formViewModel.confirmPw = ""
                        formViewModel.showErrorConfirmPw = false
                    })
                }
                Spacer().frame(height: 9 * DynamicSizeFactor.factor())
                if formViewModel.showErrorConfirmPw {
                    errorMessage("비밀번호가 일치하지 않아요")
                }
            }
        }
    }
    
    private func errorMessage(_ message: String) -> some View {
        Text(message)
            .padding(.leading, 20 * DynamicSizeFactor.factor())
            .font(.B1MediumFont())
            .platformTextColor(color: Color("Red03"))
    }
    
    @ViewBuilder
    private func closeButton(isVisible: Bool, action: @escaping () -> Void) -> some View {
        if isVisible {
            Button(action: action, label: {
                HStack {
                    Image("icon_close_filled_primary")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                }
                .padding(.leading, 268 * DynamicSizeFactor.factor())
                .padding(.top, 30 * DynamicSizeFactor.factor())
                .frame(maxWidth: .infinity)
            })
        }
    }
}

#Preview {
    ResetPwFormView(formViewModel: SignUpFormViewModel())
}
