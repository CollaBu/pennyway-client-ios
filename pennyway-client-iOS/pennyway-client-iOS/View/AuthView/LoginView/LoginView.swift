import SwiftUI

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @State private var goToInquiryView: Bool = false
    var body: some View {
        NavigationAvailable {
            ZStack {
                VStack {
                    ScrollView {
                        InputFormView(loginViewModel: loginViewModel) // Id, Pw 입력 폼

                        LoginOAuthButtonView()

                        Spacer().frame(height: 3 * DynamicSizeFactor.factor())

                        AdditionalOptionView()
                        Spacer()
                    }
                }
                VStack {
                    Spacer()
                    Button(action: {
                        goToInquiryView = true
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14)
                                .frame(maxWidth: 115 * DynamicSizeFactor.factor(), maxHeight: 25 * DynamicSizeFactor.factor())
                                .platformTextColor(color: Color("Gray02"))

                            Text("로그인에 문제가 발생했나요?")
                                .platformTextColor(color: Color("Gray04"))
                                .font(.B3MediumFont())
                                .padding(.horizontal, 8 * DynamicSizeFactor.factor())
                        }
                        .padding(.bottom, 34)
                    })
                }
                .edgesIgnoringSafeArea(.bottom)

                NavigationLink(destination: InquiryView(), isActive: $goToInquiryView) {
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    LoginView(loginViewModel: LoginViewModel())
}
