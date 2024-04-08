import SwiftUI

struct LoginFormView: View {
    @ObservedObject var viewModel: LoginFormViewModel
    @StateObject var kakaoOAuthViewModel: KakaoOAuthViewModel = KakaoOAuthViewModel()
    @StateObject var googleOAuthViewModel: GoogleOAuthViewModel = GoogleOAuthViewModel()
    @StateObject var appleOAtuthViewModel: AppleOAtuthViewModel = AppleOAtuthViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    InputFormView(viewModel: LoginFormViewModel()) // Id, Pw 입력 폼
                    
                    OauthButtonView()
                    
                    AdditionalOptionView()
                    Spacer()
                }
            }
            
            VStack {
                Spacer()
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
                    .padding(.bottom, 34)
                })
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    LoginFormView(viewModel: LoginFormViewModel())
}
