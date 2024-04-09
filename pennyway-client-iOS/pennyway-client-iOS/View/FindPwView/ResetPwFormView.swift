
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
                        formViewModel.validateForm()
                    }, isSecureText: true)

                    if formViewModel.showErrorPassword {
                        HStack {
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

                ZStack {
                    CustomInputView(inputText: $formViewModel.confirmPw, titleText: "비밀번호 확인", onCommit: {
                        formViewModel.validateConfirmPw()
                        formViewModel.validateForm()
                    }, isSecureText: true)

                    if formViewModel.showErrorConfirmPw {
                        HStack {
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

            Spacer() //수정 필요
            Spacer()
            Spacer()
            Spacer()
        }
        Spacer()
    }
}

#Preview {
    ResetPwFormView(formViewModel: SignUpFormViewModel())
}
