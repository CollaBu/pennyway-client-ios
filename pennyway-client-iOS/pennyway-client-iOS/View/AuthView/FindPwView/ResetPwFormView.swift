
import SwiftUI

struct ResetPwFormView: View {
    @ObservedObject var formViewModel: SignUpFormViewModel
    @State private var isPwDeleteButtonVisible: Bool = false
    @State private var isConfirmPwDeleteButtonVisible: Bool = false

    private let maxLength = 16

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("비밀번호")
                    .padding(.horizontal, 20)
                    .font(.pretendard(.regular, size: 12))
                    .platformTextColor(color: Color("Gray04"))

                Spacer().frame(height: 13 * DynamicSizeFactor.factor())

                HStack(spacing: 11 * DynamicSizeFactor.factor()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color("Gray01"))
                            .frame(height: 46 * DynamicSizeFactor.factor())

                        SecureField("", text: $formViewModel.password, onCommit: {
                            Log.debug("pw: \(formViewModel.password)")
                            formViewModel.validatePassword()
                            isPwDeleteButtonVisible = false
                        })
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.leading, 13 * DynamicSizeFactor.factor())
                        .padding(.vertical, 16 * DynamicSizeFactor.factor())
                        .font(.pretendard(.medium, size: 14))
                        .onChange(of: formViewModel.password) { newValue in
                            if newValue.count > maxLength {
                                formViewModel.password = String(newValue.prefix(maxLength))
                            }
                            isPwDeleteButtonVisible = !newValue.isEmpty
                        }

                        handleDeleteButtonTapped(isVisible: !formViewModel.password.isEmpty && isPwDeleteButtonVisible, action: {
                            formViewModel.password = ""
                            formViewModel.showErrorPassword = false
                            formViewModel.validatePwForm()
                            isPwDeleteButtonVisible = false
                        })
                    }
                }
                .padding(.horizontal, 20)

                Spacer().frame(height: 9 * DynamicSizeFactor.factor())

                if formViewModel.showErrorPassword {
                    errorMessage("숫자와 영문 소문자를 하나 이상 사용하여\n8~16자의 비밀번호를 만들어주세요")
                    Spacer().frame(height: 24 * DynamicSizeFactor.factor())

                } else {
                    Spacer().frame(height: 21 * DynamicSizeFactor.factor())
                }

                Text("비밀번호 확인")
                    .padding(.horizontal, 20)
                    .font(.pretendard(.regular, size: 12))
                    .platformTextColor(color: Color("Gray04"))

                HStack(spacing: 11 * DynamicSizeFactor.factor()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color("Gray01"))
                            .frame(height: 46 * DynamicSizeFactor.factor())

                        SecureField("", text: $formViewModel.confirmPw, onCommit: {
                            Log.debug("confirmPw: \(formViewModel.confirmPw)")
                            formViewModel.validateConfirmPw()
                            isConfirmPwDeleteButtonVisible = false
                        })
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.leading, 13 * DynamicSizeFactor.factor())
                        .padding(.vertical, 16 * DynamicSizeFactor.factor())
                        .font(.pretendard(.medium, size: 14))
                        .onChange(of: formViewModel.confirmPw) { newValue in
                            if newValue.count > maxLength {
                                formViewModel.confirmPw = String(newValue.prefix(maxLength))
                            }
                            isConfirmPwDeleteButtonVisible = !newValue.isEmpty
                        }

                        handleDeleteButtonTapped(isVisible: !formViewModel.confirmPw.isEmpty && isConfirmPwDeleteButtonVisible, action: {
                            formViewModel.confirmPw = ""
                            formViewModel.showErrorConfirmPw = false
                            formViewModel.validatePwForm()
                            isConfirmPwDeleteButtonVisible = false
                        })
                    }
                }
                .padding(.horizontal, 20)

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
    private func handleDeleteButtonTapped(isVisible: Bool, action: @escaping () -> Void) -> some View {
        if isVisible {
            Button(action: {
                       action()
                   },
                   label: {
                       Image("icon_close_filled_primary")
                           .resizable()
                           .aspectRatio(contentMode: .fit)
                           .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())

                   })
                   .offset(x: 120 * DynamicSizeFactor.factor(), y: 1 * DynamicSizeFactor.factor())
        }
    }
}

#Preview {
    ResetPwFormView(formViewModel: SignUpFormViewModel())
}
