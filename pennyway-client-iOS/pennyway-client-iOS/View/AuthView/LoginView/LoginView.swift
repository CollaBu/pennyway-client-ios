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
                                .frame(maxWidth: 115 * DynamicSizeFactor.factor(), maxHeight: 25 * DynamicSizeFactor.factor())
                                .platformTextColor(color: Color("Gray02"))

                            Text("로그인에 문제가 발생했나요?")
                                .platformTextColor(color: Color("Gray04"))
                                .font(.B3MediumFont())
                                .padding(.horizontal, 8)
                        }

                    })
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())
                    .buttonStyle(BasicButtonStyleUtil())
                }

                NavigationLink(destination: InquiryView(viewModel: InquiryViewModel()), isActive: $goToInquiryView) {
                    EmptyView()
                }
                .hidden()
            }
            .edgesIgnoringSafeArea(.bottom)
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
