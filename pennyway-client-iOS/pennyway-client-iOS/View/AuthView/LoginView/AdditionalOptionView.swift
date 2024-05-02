
import SwiftUI

struct AdditionalOptionView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 9 * DynamicSizeFactor.factor()) {
            NavigationLink(destination: PhoneVerificationView()) {
                Text("회원가입")
            }
            .font(.B3MediumFont())
            .platformTextColor(color: Color("Gray04"))
            .simultaneousGesture(TapGesture().onEnded {
                OAuthRegistrationManager.shared.isOAuthRegistration = false
                OAuthRegistrationManager.shared.isExistUser = false
                OAuthRegistrationManager.shared.isOAuthUser = false
            })

            Image("icon_line_gray")
                .frame(width: 0, height: 9 * DynamicSizeFactor.factor())
                .overlay(
                    Rectangle()
                        .stroke(Color("Gray02"), lineWidth: 0.7 * DynamicSizeFactor.factor())
                )

            NavigationLink(destination: FindIDFormView()) {
                Text("아이디 찾기")
            }
            .font(.B3MediumFont())
            .platformTextColor(color: Color("Gray04"))

            Image("icon_line_gray")
                .frame(width: 0, height: 9 * DynamicSizeFactor.factor())
                .overlay(
                    Rectangle()
                        .stroke(Color("Gray02"), lineWidth: 0.7 * DynamicSizeFactor.factor())
                )

            NavigationLink(destination: FindPwView()) {
                Text("비밀번호 찾기")
            }
            .font(.B3MediumFont())
            .platformTextColor(color: Color("Gray04"))
        }
    }
}

#Preview {
    AdditionalOptionView()
}
