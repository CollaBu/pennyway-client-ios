import SwiftUI

struct InputFormView: View {
    @ObservedObject var viewModel: LoginFormViewModel

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("친구들과 함께\n간편한 자산관리")
                    .font(.pretendard(.semibold, size: 27.6))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 44.85)

                Spacer()
            }
            .padding(.leading, 23)

            Spacer().frame(height: 16.1)

            if viewModel.loginFailed != nil {
                ErrorCodeContentView()
            }

            Spacer().frame(height: 40.25)

            VStack(spacing: 10.35) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 52.9)

                    TextField("아이디 입력", text: $viewModel.id)
                        .padding(.horizontal, 23)
                        .font(.pretendard(.medium, size: 16.1))
                        .AutoCorrectionExtensions()
                        .TextAutocapitalization()

                        .ignoresSafeArea(.keyboard)
                }
                .padding(.horizontal, 23)

                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 52.9)

                    SecureField("비밀번호 입력", text: $viewModel.password)
                        .padding(.horizontal, 23)
                        .font(.pretendard(.medium, size: 16.1))
                        .textContentType(.password)
                        .ignoresSafeArea(.keyboard)
                }
                .padding(.horizontal, 23)

                Spacer().frame(height: 4)

                VStack {
                    CustomBottomButton(action: {
                        viewModel.loginAPI()

                    }, label: "로그인", isFormValid: .constant(true)) // 수정
                }

                Spacer().frame(height: 21.85)
            }
        }
    }
}

#Preview {
    InputFormView(viewModel: LoginFormViewModel())
}
