import SwiftUI

struct InputFormView: View {
    @ObservedObject var viewModel: LoginFormViewModel

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("친구들과 함께\n간편한 자산관리")
                    .font(.pretendard(.semibold, size: 28.8))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 39)

                Spacer()
            }
            .padding(.leading, 20)

            Spacer().frame(height: 14)

            if viewModel.loginFailed != nil {
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

                        .ignoresSafeArea(.keyboard)
                }
                .padding(.horizontal, 20)

                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 46)

                    SecureField("비밀번호 입력", text: $viewModel.password)
                        .padding(.horizontal, 20)
                        .font(.pretendard(.medium, size: 14))
                        .textContentType(.password)
                        .ignoresSafeArea(.keyboard)
                }
                .padding(.horizontal, 20)

                Spacer().frame(height: 4)

                VStack {
                    CustomBottomButton(action: {
                        viewModel.loginAPI()

                    }, label: "로그인", isFormValid: .constant(true)) // 수정
                }

                Spacer().frame(height: 19)
            }
        }
    }
}

#Preview {
    InputFormView(viewModel: LoginFormViewModel())
}
