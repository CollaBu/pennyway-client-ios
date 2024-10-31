import SwiftUI

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @State private var goToInquiryView: Bool = false
    @EnvironmentObject var viewStateManager: ViewStateManager

    var body: some View {
        NavigationAvailable {
            ZStack {
                VStack {
                    InputFormView(loginViewModel: loginViewModel) // Id, Pw 입력 폼

                    LoginOAuthButtonView()

                    AdditionalOptionView()
                }
                .padding(.bottom, 70 * DynamicSizeFactor.factor())

                VStack {
                    Spacer()
                    Button(action: {
                        goToInquiryView = true
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(maxWidth: 123 * DynamicSizeFactor.factor(), maxHeight: 28 * DynamicSizeFactor.factor())
                                .platformTextColor(color: Color("Gray02"))

                            Text("로그인에 문제가 발생했나요?")
                                .platformTextColor(color: Color("Gray04"))
                                .font(.B3MediumFont())
                                .padding(.horizontal, 8 * DynamicSizeFactor.factor())
                        }

                    })
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())
                    .buttonStyle(BasicButtonStyleUtil())
                }
                .edgesIgnoringSafeArea(.bottom)

                NavigationLink(destination: InquiryView(viewModel: InquiryViewModel()), isActive: $goToInquiryView) {
                    EmptyView()
                }
                .hidden()
            }
            .onAppear {
                viewStateManager.setCurrentView(self)
            }
        }
        .analyzeEvent(AuthEvents.loginView)
    }
}

#Preview {
    LoginView(loginViewModel: LoginViewModel())
}
