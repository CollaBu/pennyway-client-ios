import SwiftUI

struct SignUpFormView: View {
    // MARK: Internal

    @ObservedObject var formViewModel: SignUpFormViewModel
    @State private var isOAuthRegistration = OAuthRegistrationManager.shared.isOAuthRegistration
    @State private var isExistUser = OAuthRegistrationManager.shared.isExistUser

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("회원가입")
                    .font(.pretendard(.semibold, size: 24))
                    .padding(.horizontal, 20)
                
                Spacer().frame(height: 32)
                VStack(alignment: .leading, spacing: 21) {
                    if !isOAuthRegistration || !isExistUser {
                        VStack(alignment: .leading, spacing: 9) {
                            CustomInputView(inputText: $formViewModel.name, titleText: "이름", onCommit: {
                                formViewModel.validateName()
                                formViewModel.validateForm()
                            }, isSecureText: false)
                            
                            if formViewModel.showErrorName {
                                Text("한글, 영문 대/소문자만 가능해요")
                                    .padding(.leading, 20)
                                    .font(.pretendard(.medium, size: 12))
                                    .platformTextColor(color: Color("Red03"))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 9) {
                            CustomInputView(inputText: $formViewModel.id, titleText: "아이디", onCommit: {
                                formViewModel.validateID()
                                formViewModel.validateForm()
                            }, isSecureText: false)
                            
                            if formViewModel.showErrorID {
                                Text("영문 소문자, 특수기호 -, _, . 만 사용하여,\n5~20자의 아이디를 입력해주세요")
                                    .padding(.leading, 20)
                                    .font(.pretendard(.medium, size: 12))
                                    .platformTextColor(color: Color("Red03"))
                            }
                        }
                    }
                   
                    if isExistUser {
                        VStack(alignment: .leading, spacing: 9) {
                            CustomInputView(inputText: $formViewModel.password, titleText: "비밀번호", onCommit: {
                                print(formViewModel.password)
                                formViewModel.validatePassword()
                                formViewModel.validateForm()
                            }, isSecureText: true)
                            
                            if formViewModel.showErrorPassword {
                                Text("적어도 하나 이상의 소문자 알파벳과 숫자를 포함하여\n8~16자의 비밀번호를 입력해주세요")
                                    .padding(.leading, 20)
                                    .font(.pretendard(.medium, size: 12))
                                    .platformTextColor(color: Color("Red03"))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 9) {
                            CustomInputView(inputText: $formViewModel.confirmPw, titleText: "비밀번호 확인", onCommit: {
                                formViewModel.validateConfirmPw()
                                formViewModel.validateForm()
                                print(formViewModel.confirmPw)
                            }, isSecureText: true)
                            
                            if formViewModel.showErrorConfirmPw {
                                Text("비밀번호가 일치하지 않아요")
                                    .padding(.leading, 20)
                                    .font(.pretendard(.medium, size: 12))
                                    .platformTextColor(color: Color("Red03"))
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SignUpFormView(formViewModel: SignUpFormViewModel())
}
