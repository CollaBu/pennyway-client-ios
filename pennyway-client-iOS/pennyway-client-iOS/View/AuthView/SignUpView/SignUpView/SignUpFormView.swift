import SwiftUI

struct SignUpFormView: View {
    @ObservedObject var formViewModel: SignUpFormViewModel
    @State private var isOAuthRegistration = OAuthRegistrationManager.shared.isOAuthRegistration
    @State private var isExistUser = OAuthRegistrationManager.shared.isExistUser
    @State private var isOAuthUser = OAuthRegistrationManager.shared.isOAuthUser
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("회원가입")
                    .font(.pretendard(.semibold, size: 24))
                    .padding(.horizontal, 20)
                
                Spacer().frame(height: 32)
                
                VStack(alignment: .leading, spacing: 21) {
                    if !isOAuthRegistration && (!isExistUser && !isOAuthUser) {
                        allInputFields()
                    } else if isOAuthRegistration && !isExistUser {
                        nameAndIDFields()
                    } else if !isOAuthRegistration && isOAuthUser {
                        passwordFields()
                    }
                }
            }
        }
    }
    
    /// All input fields
    private func allInputFields() -> some View {
        VStack(alignment: .leading, spacing: 9) {
            CustomInputView(inputText: $formViewModel.name, titleText: "이름", onCommit: {
                formViewModel.validateName()
                formViewModel.validateForm()
            }, isSecureText: false)
            
            if formViewModel.showErrorName {
                errorMessage("한글, 영문 대/소문자만 가능해요")
            }
            
            CustomInputView(inputText: $formViewModel.id, titleText: "아이디", onCommit: {
                formViewModel.checkDuplicateUserNameApi { isDuplicate in
                    if !isDuplicate {
                        formViewModel.validateID()
                        formViewModel.validateForm()
                    }
                }
            }, isSecureText: false)
            
            if formViewModel.showErrorID {
                errorMessage("영문 소문자, 특수기호 -, _, . 만 사용하여,\n5~20자의 아이디를 입력해주세요")
            }

            if formViewModel.isDuplicateUserName {
                errorMessage("이미 사용 중인 아이디예요")
            }
            passwordFields()
        }
    }
    
    /// Name and ID fields
    private func nameAndIDFields() -> some View {
        VStack(alignment: .leading, spacing: 9) {
            CustomInputView(inputText: $formViewModel.name, titleText: "이름", onCommit: {
                formViewModel.validateName()
                formViewModel.validateForm()
            }, isSecureText: false)
            
            if formViewModel.showErrorName {
                errorMessage("한글, 영문 대/소문자만 가능해요")
            }
            
            CustomInputView(inputText: $formViewModel.id, titleText: "아이디", onCommit: {
                formViewModel.checkDuplicateUserNameApi { isDuplicate in
                    if !isDuplicate {
                        formViewModel.validateID()
                        formViewModel.validateForm()
                    }
                }
            }, isSecureText: false)
            
            if formViewModel.showErrorID {
                errorMessage("영문 소문자, 특수기호 -, _, . 만 사용하여,\n5~20자의 아이디를 입력해주세요")
            }
 
            if formViewModel.isDuplicateUserName {
                errorMessage("이미 사용 중인 아이디예요")
            }
        }
    }
    
    /// Password fields
    private func passwordFields() -> some View {
        VStack(alignment: .leading, spacing: 9) {
            CustomInputView(inputText: $formViewModel.password, titleText: "비밀번호", onCommit: {
                formViewModel.validatePassword()
                formViewModel.validateForm()
            }, isSecureText: true)
            
            if formViewModel.showErrorPassword {
                errorMessage("적어도 하나 이상의 소문자 알파벳과 숫자를 포함하여\n8~16자의 비밀번호를 입력해주세요")
            }
            
            CustomInputView(inputText: $formViewModel.confirmPw, titleText: "비밀번호 확인", onCommit: {
                formViewModel.validateConfirmPw()
                formViewModel.validateForm()
            }, isSecureText: true)
            
            if formViewModel.showErrorConfirmPw {
                errorMessage("비밀번호가 일치하지 않아요")
            }
        }
    }
    
    /// Error message
    private func errorMessage(_ message: String) -> some View {
        Text(message)
            .padding(.leading, 20)
            .font(.pretendard(.medium, size: 12))
            .platformTextColor(color: Color("Red03"))
    }
}

#Preview {
    SignUpFormView(formViewModel: SignUpFormViewModel())
}
