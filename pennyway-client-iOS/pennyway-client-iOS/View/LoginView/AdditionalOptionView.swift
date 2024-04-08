
import SwiftUI

struct AdditionalOptionView: View {
    var body: some View {
        HStack(alignment: .center) {
            NavigationLink(destination: NumberVerificationView()) {
                Text("회원가입")
                    .font(.pretendard(.medium, size: 9))
                    .platformTextColor(color: Color("Gray04"))
            }
            .simultaneousGesture(TapGesture().onEnded {
                OAuthRegistrationManager.shared.isOAuthRegistration = false
                OAuthRegistrationManager.shared.isExistUser = true
            })

            Button(action: { // 해당 버튼들은 추후 NavigationLink로 수정 할 것
            }, label: {
                Text("아이디 찾기")
                    .font(.pretendard(.medium, size: 9))
                    .platformTextColor(color: Color("Gray04"))
            })

            Button(action: { // 해당 버튼들은 추후 NavigationLink로 수정 할 것
            }, label: {
                Text("비밀번호 찾기")
                    .font(.pretendard(.medium, size: 9))
                    .platformTextColor(color: Color("Gray04"))
            })
        }
        .padding(.horizontal, 86)
    }
}

#Preview {
    AdditionalOptionView()
}
