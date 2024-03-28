import SwiftUI

struct SignUpFormView: View {
    
    @ObservedObject var formViewModel: SignUpFormViewModel
    @State private var shouldNavigate = false

    var body: some View {
        
        ScrollView() {
            VStack(alignment: .leading) {
                Text("회원가입")
                    .font(.pretendard(.semibold, size: 24))
                    .padding(.horizontal,20)
                
                Spacer().frame(height: 32)
                VStack(alignment: .leading, spacing: 21){
                    VStack(alignment:.leading, spacing: 9) {
                        CustomInputView(inputText: $formViewModel.name, titleText: "이름", onCommit: {
                            formViewModel.validateName()
                            formViewModel.validateForm()
                        }, isSecureText: false)
                        
                        if formViewModel.showErrorName{
                            Text("입력 포멧 관련 문구")
                                .padding(.leading, 20)
                                .font(.pretendard(.medium, size: 12))
                                .platformTextColor(color: Color("Red03"))
                        }
                    }
                    
                    VStack(alignment:.leading, spacing: 9) {
                        CustomInputView(inputText: $formViewModel.id, titleText: "아이디", onCommit: {
                            formViewModel.validateID()
                            formViewModel.validateForm()
                        }, isSecureText: false)
                        
                        if formViewModel.showErrorID{
                            Text("입력 포멧 관련 문구")
                                .padding(.leading, 20)
                                .font(.pretendard(.medium, size: 12))
                                .platformTextColor(color: Color("Red03"))
                        }
                    }
                    
                    VStack(alignment:.leading, spacing:9) {
                        CustomInputView(inputText: $formViewModel.password, titleText: "비밀번호", onCommit: {
                            
                            print(formViewModel.password)
                            formViewModel.validatePassword()
                            formViewModel.validateForm()
                        }, isSecureText: true)
                        
                        if formViewModel.showErrorPassword{
                            Text("입력 포멧 관련 문구")
                                .padding(.leading, 20)
                            
                                .font(.pretendard(.medium, size: 12))
                                .platformTextColor(color: Color("Red03"))
                        }
                    }
                    
                    VStack(alignment:.leading, spacing:9) {
                        CustomInputView(inputText: $formViewModel.confirmPw, titleText: "비밀번호 확인", onCommit: {
                            formViewModel.validateConfirmPw()
                            formViewModel.validateForm()
                        }, isSecureText: true)
                        
                        if formViewModel.showErrorConfirmPw{
                            Text("입력 포멧 관련 문구")
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
#Preview {
    SignUpFormView(formViewModel: SignUpFormViewModel())
}

