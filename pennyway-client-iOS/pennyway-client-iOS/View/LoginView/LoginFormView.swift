import SwiftUI

struct LoginFormView: View {

    var body: some View {
        VStack {
            ScrollView {
                InputFormView(viewModel: LoginFormViewModel()) // Id, Pw 입력 폼
                
                OauthButtonView()
                // Spacer().frame(height: 15)
            
                AdditionalOptionView()
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
    LoginFormView()
}