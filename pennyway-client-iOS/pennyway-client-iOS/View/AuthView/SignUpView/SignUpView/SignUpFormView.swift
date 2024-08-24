import SwiftUI

struct SignUpFormView: View {
    @ObservedObject var formViewModel: SignUpFormViewModel
    @State private var isOAuthRegistration = OAuthRegistrationManager.shared.isOAuthRegistration
    @State private var isExistUser = OAuthRegistrationManager.shared.isExistUser
    @State private var isOAuthUser = OAuthRegistrationManager.shared.isOAuthUser
    
    var body: some View {
        // ScrollView {
        VStack(alignment: .leading) {
            Text("회원가입")
                .font(.H1SemiboldFont())
                .padding(.horizontal, 20)
                
            Spacer().frame(height: 32 * DynamicSizeFactor.factor())
                
            VStack(alignment: .leading, spacing: 21 * DynamicSizeFactor.factor()) {
                if !isOAuthRegistration && (!isExistUser && !isOAuthUser) {
                    allInputFields()
                        .analyzeEvent(AuthEvents.generalSignUpView)
                } else if isOAuthRegistration && !isExistUser {
                    nameAndIDFields()
                        .analyzeEvent(AuthEvents.oauthSignUpView)
                } else if !isOAuthRegistration && isOAuthUser {
                    passwordFields()
                        .analyzeEvent(AuthEvents.generalSignSycnView)
                }
            }
        }
        // }
    }
    
    /// All input fields
    private func allInputFields() -> some View {
        VStack(alignment: .leading, spacing: 9 * DynamicSizeFactor.factor()) {
            nameAndIDFields()
            Spacer()
            passwordFields()
        }
    }
    
    /// Name and ID fields
    private func nameAndIDFields() -> some View {
        VStack(alignment: .leading, spacing: 9 * DynamicSizeFactor.factor()) {
            CustomInputView(inputText: $formViewModel.name, titleText: "이름", onCommit: {
                formViewModel.validateName()
                formViewModel.validateForm()
            }, isSecureText: false, showDeleteButton: true,
            deleteAction: {
                formViewModel.name = ""
                formViewModel.showErrorName = false
                formViewModel.validateForm()
            })
            
            if formViewModel.showErrorName {
                ErrorText(message: "한글과 영문 대, 소문자만 가능해요", color: Color("Red03"))
                Spacer().frame(height: 3 * DynamicSizeFactor.factor())

            } else {
                Spacer().frame(height: 4 * DynamicSizeFactor.factor())
            }
            
            CustomInputView(inputText: $formViewModel.id, titleText: "아이디", onCommit: {
                formViewModel.checkDuplicateUserNameApi { isDuplicate in
                    if !isDuplicate {
                        formViewModel.validateID()
                        formViewModel.validateForm()
                    }
                }
            }, isSecureText: false, showDeleteButton: true,
            deleteAction: {
                formViewModel.id = ""
                formViewModel.validateForm()
                formViewModel.showErrorID = false
            })
            
            if formViewModel.showErrorID {
                ErrorText(message: "영문 소문자, 특수기호 (-), (_), (.) 만 사용하여,\n5~20자의 아이디를 입력해 주세요", color: Color("Red03"))
            }
 
            if formViewModel.isDuplicateUserName {
                ErrorText(message: "이미 사용 중인 아이디예요", color: Color("Red03"))
            }
        }
    }
    
    /// Password fields
    private func passwordFields() -> some View {
        VStack(alignment: .leading, spacing: 9 * DynamicSizeFactor.factor()) {
            CustomInputView(inputText: $formViewModel.password, titleText: "비밀번호", onCommit: {
                formViewModel.validatePassword()
                formViewModel.validateForm()
            }, isSecureText: true, showDeleteButton: true,
            deleteAction: {
                formViewModel.password = ""
                formViewModel.showErrorPassword = false
                formViewModel.validateForm()
            })
            
            if formViewModel.showErrorPassword {
                ErrorText(message: "숫자와 영문 소문자를 하나 이상 사용하여\n8~16자의 비밀번호를 만들어주세요", color: Color("Red03"))
                
                Spacer().frame(height: 3 * DynamicSizeFactor.factor())

            } else {
                Spacer().frame(height: 4 * DynamicSizeFactor.factor())
            }
            
            CustomInputView(inputText: $formViewModel.confirmPw, titleText: "비밀번호 확인", onCommit: {
                formViewModel.validateConfirmPw()
                formViewModel.validateForm()
            }, isSecureText: true, showDeleteButton: true,
            deleteAction: {
                formViewModel.confirmPw = ""
                formViewModel.validateForm()
                formViewModel.showErrorConfirmPw = false
            })
            
            if formViewModel.showErrorConfirmPw {
                ErrorText(message: "비밀번호가 일치하지 않아요", color: Color("Red03"))
                Spacer().frame(height: 3 * DynamicSizeFactor.factor())

            } else {
                Spacer().frame(height: 4 * DynamicSizeFactor.factor())
            }
        }
    }
}

#Preview {
    SignUpFormView(formViewModel: SignUpFormViewModel())
}
