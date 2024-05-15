import SwiftUI

struct InputFormView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @EnvironmentObject var authViewModel: AppViewModel

    @State private var isLoginSuccessful = true

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("친구들과 함께\n간편한 자산관리")
                    .font(.H1SemiboldFont())
                    .multilineTextAlignment(.leading)
                    .padding(.top, 40 * DynamicSizeFactor.factor())

                Spacer()
            }
            .padding(.leading, 20)

            if loginViewModel.showErrorCodeContent {
                Spacer().frame(height: 14 * DynamicSizeFactor.factor())
                ErrorCodeContentView()
                Spacer().frame(height: 35 * DynamicSizeFactor.factor())
            } else {
                Spacer().frame(height: 49 * DynamicSizeFactor.factor())
            }

            VStack(spacing: 9 * DynamicSizeFactor.factor()) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 46 * DynamicSizeFactor.factor())

                    if loginViewModel.username.isEmpty {
                        Text("아이디 입력")
                            .platformTextColor(color: Color("Gray03"))
                            .padding(.leading, 13 * DynamicSizeFactor.factor())
                            .font(.H4MediumFont())
                    }
                    TextField("", text: $loginViewModel.username)
                        .padding(.horizontal, 13 * DynamicSizeFactor.factor())
                        .font(.H4MediumFont())
                        .AutoCorrectionExtensions()
                        .TextAutocapitalization()
                        .ignoresSafeArea(.keyboard)
                }
                .padding(.horizontal, 20)

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 46 * DynamicSizeFactor.factor())

                    if loginViewModel.password.isEmpty {
                        Text("비밀번호 입력")
                            .platformTextColor(color: Color("Gray03"))
                            .padding(.leading, 13 * DynamicSizeFactor.factor())
                            .font(.H4MediumFont())
                    }
                    SecureField("", text: $loginViewModel.password)
                        .padding(.horizontal, 13 * DynamicSizeFactor.factor())
                        .font(.H4MediumFont())
                        .textContentType(.password)
                        .ignoresSafeArea(.keyboard)
                }
                .padding(.horizontal, 20)

                Spacer().frame(height: 0 * DynamicSizeFactor.factor()) // 확인 필요

                VStack {
                    CustomBottomButton(action: {
                        handleLogin()

                    }, label: "로그인", isFormValid: .constant(true)) 
                }

                Spacer().frame(height: 14 * DynamicSizeFactor.factor())
            }
        }
    }

    func handleLogin() {
        loginViewModel.loginApi { success in
            DispatchQueue.main.async {
                if success {
                    authViewModel.login()
                } else {
                    Log.error("fail login")
                }
            }
        }
    }
}

#Preview {
    InputFormView(loginViewModel: LoginViewModel())
}
