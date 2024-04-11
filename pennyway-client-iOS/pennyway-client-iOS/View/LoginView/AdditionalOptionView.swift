
import SwiftUI

struct AdditionalOptionView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 9) {
            NavigationLink(destination: PhoneVerificationView()) {
                Text("회원가입")
            }
            .font(.B3MediumFont())
            .platformTextColor(color: Color("Gray04"))
            .simultaneousGesture(TapGesture().onEnded {
                OAuthRegistrationManager.shared.isOAuthRegistration = false
                OAuthRegistrationManager.shared.isExistUser = true
            })

            Image("icon_line_gray")
                .frame(width: 0, height: 9)
                .overlay(
                    Rectangle()
                        .stroke(Color("Gray02"), lineWidth: 0.69506)
                )

            NavigationLink(destination: FindIDFormView()) {
                Text("아이디 찾기")
            }
            .font(.B3MediumFont())
            .platformTextColor(color: Color("Gray04"))

            Image("icon_line_gray")
                .frame(width: 0, height: 9)
                .overlay(
                    Rectangle()
                        .stroke(Color("Gray02"), lineWidth: 0.69506)
                )

            NavigationLink(destination: FindPwView()) {
                Text("비밀번호 찾기")
            }
            .font(.B3MediumFont())
            .platformTextColor(color: Color("Gray04"))
        }
        .padding(.horizontal, 86)
    }
}

#Preview {
    AdditionalOptionView()
}
