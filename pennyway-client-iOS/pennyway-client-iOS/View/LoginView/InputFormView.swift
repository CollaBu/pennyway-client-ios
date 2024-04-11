import SwiftUI

struct InputFormView: View {
    @ObservedObject var viewModel: LoginFormViewModel

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("친구들과 함께\n간편한 자산관리")
                    .font(.H1SemiboldFont())
                    .multilineTextAlignment(.leading)
                    .padding(.top, 40 * DynamicSizeFactor.factor())

                Spacer()
            }
            .padding(.leading, 20 * DynamicSizeFactor.factor())

            Spacer().frame(height: 14 * DynamicSizeFactor.factor())

            if viewModel.loginFailed != nil {
                ErrorCodeContentView()
            }

            Spacer().frame(height: 35 * DynamicSizeFactor.factor())

            VStack(spacing: 9 * DynamicSizeFactor.factor()) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 46 * DynamicSizeFactor.factor())

                    TextField("아이디 입력", text: $viewModel.id)
                        .padding(.horizontal, 13 * DynamicSizeFactor.factor())
                        .font(.H4MediumFont())
                        .AutoCorrectionExtensions()
                        .TextAutocapitalization()

                        .ignoresSafeArea(.keyboard)
                }
                .padding(.horizontal, 20 * DynamicSizeFactor.factor())

                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 46 * DynamicSizeFactor.factor())

                    SecureField("비밀번호 입력", text: $viewModel.password)
                        .padding(.horizontal, 13 * DynamicSizeFactor.factor())
                        .font(.H4MediumFont())
                        .textContentType(.password)
                        .ignoresSafeArea(.keyboard)
                }
                .padding(.horizontal, 20 * DynamicSizeFactor.factor())

                Spacer().frame(height: 4 * DynamicSizeFactor.factor())

                VStack {
                    CustomBottomButton(action: {
                        viewModel.loginAPI()

                    }, label: "로그인", isFormValid: .constant(true)) // 수정
                }

                Spacer().frame(height: 14 * DynamicSizeFactor.factor())
            }
        }
    }
}

#Preview {
    InputFormView(viewModel: LoginFormViewModel())
}
