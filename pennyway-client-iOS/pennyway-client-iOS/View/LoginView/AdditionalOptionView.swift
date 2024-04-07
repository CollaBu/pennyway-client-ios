
import SwiftUI

struct AdditionalOptionView: View {
    var body: some View {
        HStack(alignment: .center) {
            NavigationLink(destination: NumberVerificationView()) {
                Text("회원가입")
            }
            .font(.pretendard(.medium, size: 9))
            .platformTextColor(color: Color("Gray04"))

            Image("icon_line_gray")
                .frame(width: 0, height: 9)
                .overlay(
                    Rectangle()
                        .stroke(Color("Gray02"), lineWidth: 0.69506)
                )

            NavigationLink(destination: FindIDFormView()) {
                Text("아이디 찾기")
            }
            .font(.pretendard(.medium, size: 9))
            .platformTextColor(color: Color("Gray04"))

            NavigationLink(destination: NumberVerificationView()) {
                Text("비밀번호 찾기")
            }
            .font(.pretendard(.medium, size: 9))
            .platformTextColor(color: Color("Gray04"))
        }
        .padding(.horizontal, 86)
    }
}

#Preview {
    AdditionalOptionView()
}
