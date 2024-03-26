import SwiftUI

struct SignUpFormView: View {
<<<<<<< HEAD
=======
//    @Binding var name: String
//    @Binding var id: String
//    @Binding var password: String
//    @Binding var confirmPw: String
//    @State var showErrorName = false
>>>>>>> 7508c42c783da61113f2cb8320cd89aad05ce5a6
    
    @StateObject private var viewModel = SignUpFormViewModel()
    
    var body: some View {
        
        VStack(alignment: .leading){
            Text("회원가입")
                .font(.pretendard(.semibold, size: 24))
                .padding(.horizontal,20)
            
            Spacer().frame(height: 32)
            
<<<<<<< HEAD
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 21){
                    VStack(alignment:.leading, spacing: 9) {
                        CustomInputView(inputText: $viewModel.name, titleText: "이름", onCommit: {
                            viewModel.validateName()
                        })
                        
                        if viewModel.showErrorName{
                            Text("입력 포멧 관련 문구")
                                .padding(.leading, 20)
                                .font(.pretendard(.medium, size: 12))
                                .platformTextColor(color: Color("Red03"))
                        }
                    }
                    
                    VStack(alignment:.leading, spacing: 9) {
                        CustomInputView(inputText: $viewModel.id, titleText: "아이디", onCommit: {
                            viewModel.validateID()
                        })
                        
                        if viewModel.showErrorID{
                            Text("입력 포멧 관련 문구")
                                .padding(.leading, 20)
                                .font(.pretendard(.medium, size: 12))
                                .platformTextColor(color: Color("Red03"))
                        }
                    }
                    
                    VStack(alignment:.leading, spacing:9) {
                        CustomInputView(inputText: $viewModel.password, titleText: "비밀번호", onCommit: {
                            viewModel.validatePassword()
                        })
                        
                        if viewModel.showErrorPassword{
                            Text("입력 포멧 관련 문구")
                                .padding(.leading, 20)
                            
                                .font(.pretendard(.medium, size: 12))
                                .platformTextColor(color: Color("Red03"))
                        }
                    }
                    
                    VStack(alignment:.leading, spacing:9) {
                        CustomInputView(inputText: $viewModel.confirmPw, titleText: "비밀번호 확인", onCommit: {
                            viewModel.validateConfirmPw()
                        })
                        
                        if viewModel.showErrorConfirmPw{
                            Text("입력 포멧 관련 문구")
                                .padding(.leading, 20)
                                .font(.pretendard(.medium, size: 12))
                                .platformTextColor(color: Color("Red03"))
=======
            ScrollView() {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 21){
                        VStack(alignment:.leading, spacing: 9) {
                            CustomInputView(inputText: $viewModel.name, titleText: "이름", onCommit: {
                                viewModel.validateName()
                            })

                                if viewModel.showErrorName{
                                    Text("입력 포멧 관련 문구")
                                    .padding(.leading, 20)
                                    .font(.pretendard(.medium, size: 12))
                                    .platformTextColor(color: Color("Red03"))
                                }
                        }
                        
                        VStack(alignment:.leading, spacing: 9) {
                            CustomInputView(inputText: $viewModel.id, titleText: "아이디", onCommit: {
                                viewModel.validateID()
                            })

                            if viewModel.showErrorID{
                                Text("입력 포멧 관련 문구")
                                .padding(.leading, 20)
                                .font(.pretendard(.medium, size: 12))
                                .platformTextColor(color: Color("Red03"))
                            }
                        }
                        
                        VStack(alignment:.leading, spacing:9) {
                            CustomInputView(inputText: $viewModel.password, titleText: "비밀번호", onCommit: {
                                viewModel.validatePassword()
                            })

                            if viewModel.showErrorPassword{
                                Text("입력 포멧 관련 문구")
                                .padding(.leading, 20)
                                
                                .font(.pretendard(.medium, size: 12))
                                .platformTextColor(color: Color("Red03"))
                            }
                        }
                        
                        VStack(alignment:.leading, spacing:9) {
                            CustomInputView(inputText: $viewModel.confirmPw, titleText: "비밀번호 확인", onCommit: {
                                viewModel.validateConfirmPw()
                            })

                            if viewModel.showErrorConfirmPw{
                                Text("입력 포멧 관련 문구")
                                .padding(.leading, 20)
                                .font(.pretendard(.medium, size: 12))
                                .platformTextColor(color: Color("Red03"))
                            }
>>>>>>> 7508c42c783da61113f2cb8320cd89aad05ce5a6
                        }
                    }
                }
            }
        }
        
    }
}

#Preview {
    SignUpFormView()
}
