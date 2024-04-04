import SwiftUI

struct LoginFormView: View {
    @ObservedObject var viewModel: LoginFormViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    HStack(alignment: .top) {
                        Text("친구들과 함께 간편한 자산관리")
                            .font(.pretendard(.semibold, size: 24))
                            .multilineTextAlignment(.leading)
                            .padding(.top, 39)
                        
                        Spacer().frame(height: 49)
                    }
                    .padding(.leading, 20)
                    
                    Spacer().frame(height: 14)
                    
                    if viewModel.loginFailed {
                        ErrorCodeContentView()
                    }
                    
                    Spacer().frame(height: 35)
                    
                    VStack(spacing: 9) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color("Gray01"))
                                .frame(height: 46)
                            
                            TextField("아이디 입력", text: $viewModel.id)
                                .padding(.horizontal, 20)
                                .font(.pretendard(.medium, size: 14))
                                .AutoCorrectionExtensions()
                                .TextAutocapitalization()
                        }
                        .padding(.horizontal, 20)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color("Gray01"))
                                .frame(height: 46)
                            
                            SecureField("비밀번호 입력", text: $viewModel.password)
                                .padding(.horizontal, 20)
                                .font(.pretendard(.medium, size: 14))
                                .textContentType(.newPassword)
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer().frame(height: 4)
                        
                        VStack {
                            CustomBottomButton(action: {
                                viewModel.login()
                                
                            }, label: "로그인", isFormValid: $viewModel.isFormValid, alwaysMint: true)
                        }
                    }
                    
                    Spacer().frame(height: 19)
                    
                    VStack(alignment: .center, spacing: 15) {
                        HStack(spacing: 10) {
                            Button(action: { // kakao
                            }, label: {
                                Image("icon_signin_kakao")
                            })
                            
                            Button(action: { // google
                            }, label: {
                                Image("icon_signin_google")
                            })
                            
                            Button(action: { // apple
                            }, label: {
                                Image("icon_signin_apple")
                            })
                        }
                        .padding(.horizontal, 100)
                        
                        HStack(alignment: .center) {
                            NavigationLink(destination: NumberVerificationView()) {
                                Text("회원가입")
                            }
                            .font(.pretendard(.medium, size: 9))
                            .platformTextColor(color: Color("Gray04"))
                            
                            Button(action: { // 해당 버튼들은 추후 NavigationLink로 수정 할 것
                            }, label: {
                                Text("아이디 찾기")
                                    .font(.pretendard(.medium, size: 9))
                                    .platformTextColor(color: Color("Gray04"))
                            })
                            
                            Button(action: { // 해당 버튼들은 추후 NavigationLink로 수정 할 것
                            }, label: {
                                Text("비밀번호 찾기")
                                    .font(.pretendard(.medium, size: 9))
                                    .platformTextColor(color: Color("Gray04"))
                            })
                        }
                        .padding(.horizontal, 86)
                    }
                }
            }

            VStack {
                Button(action: {}, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .frame(maxWidth: 115, maxHeight: 25)
                            .platformTextColor(color: Color("Gray02"))
                        
                        Text("로그인에 문제가 발생했나요?")
                            .platformTextColor(color: Color("Gray04"))
                            .font(.pretendard(.medium, size: 9))
                            .padding(8)
                    }
                    .padding(.horizontal, 103)
                    
                })
            }
            .padding(.bottom, 34)
        }
    }
}

#Preview {
    LoginFormView(viewModel: LoginFormViewModel())
}
