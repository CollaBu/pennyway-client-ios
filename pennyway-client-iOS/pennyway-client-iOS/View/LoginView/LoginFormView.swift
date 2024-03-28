import SwiftUI

struct LoginFormView: View {
    
    @ObservedObject var viewModel: LoginFormViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                HStack(alignment: .top) {
                    Text("친구들과 함께 간편한 자산관리")
                        .font(.pretendard(.semibold, size: 24))
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 20)
//                    Spacer()
                    Spacer().frame(height: 49)
//                    Spacer()
                }
                //            .padding(.top, 39)
                .border(Color.black)
                Spacer().frame(height: 49)
//                Spacer()
                
                VStack(spacing: 9) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color("Gray01"))
                            .frame(height: 46)
                        
                        TextField("아이디 입력", text: $viewModel.id)
                            .padding(.horizontal, 20)
                            .font(.pretendard(.medium, size: 14))
                        
                    }
                    .padding(.horizontal, 20)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color("Gray01"))
                            .frame(height: 46)
                        
                        TextField("비밀번호 입력", text: $viewModel.password)
                            .padding(.horizontal, 20)
                            .font(.pretendard(.medium, size: 14))
                        
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer().frame(height: 4)
                    
                    VStack {
                        CustomBottomButton(action: {
                            
                            
                        }, label: "로그인", isFormValid: $viewModel.isFormValid)
                    }
                    
                }
                
                Spacer().frame(height: 14)
                
                VStack(alignment:.center, spacing: 10) {
                    HStack {
                        Text("카카오|구글|애플")
                            .multilineTextAlignment(.center)
                    }
                    .border(Color.black)
                    .padding(.horizontal, 100)
                    
                    HStack(alignment: .center) {
                        NavigationLink(destination: NumberVerificationView()) {
                            Text("회원가입")
                        }
                        .font(.pretendard(.medium, size: 9))
                        .foregroundColor(Color("Gray04"))
                        
                        Button(action: { //해당 버튼들은 추후 NavigationLink로 수정 할 것
                            
                        }, label: {
                            Text("아이디 찾기")
                                .font(.pretendard(.medium, size: 9))
                                .foregroundColor(Color("Gray04"))
                        })
                        
                        Button(action: { //해당 버튼들은 추후 NavigationLink로 수정 할 것
                            
                        }, label: {
                            Text("비밀번호 찾기")
                                .font(.pretendard(.medium, size: 9))
                                .foregroundColor(Color("Gray04"))
                        })
                    }
                    .padding(.horizontal, 86)
                    
                }
                
                
            }
            .padding(.top, 39)
            .border(Color.black)
        }
        .border(Color.red)
    }
}

#Preview {
    LoginFormView(viewModel: LoginFormViewModel())
}
