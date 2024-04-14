
import SwiftUI

struct ResetPwFormView: View {
    @ObservedObject var formViewModel: SignUpFormViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 21) {
            VStack {
                ZStack {
                    CustomInputView(inputText: $formViewModel.password, titleText: "비밀번호", onCommit: {
                        print(formViewModel.password)
                        formViewModel.validatePassword()
                        formViewModel.validatePwForm()
                    }, isSecureText: true)

                    if formViewModel.showErrorPassword {
                        HStack { // 추후 버튼으로 변경 필요
                            Image("icon_close_filled_primary")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                        }
                        .padding(.leading, 268)
                        .padding(.top, 30)
                        .frame(maxWidth: .infinity)
                    }
                }

                Spacer().frame(height: 21)

                ZStack {
                    CustomInputView(inputText: $formViewModel.confirmPw, titleText: "비밀번호 확인", onCommit: {
                        formViewModel.validateConfirmPw()
                        formViewModel.validatePwForm()
                    }, isSecureText: true)

                    if formViewModel.showErrorConfirmPw {
                        HStack { // 추후 버튼으로 변경 필요
                            Image("icon_close_filled_primary")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                        }
                        .padding(.leading, 268)
                        .padding(.top, 30)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

#Preview {
    ResetPwFormView(formViewModel: SignUpFormViewModel())
}
