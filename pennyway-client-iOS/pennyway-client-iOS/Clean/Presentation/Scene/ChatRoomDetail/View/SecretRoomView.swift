
import SwiftUI

struct SecretRoomView: View {
    @State private var password = ""
    @State private var isNavigate = false

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Spacer().frame(height: 36 * DynamicSizeFactor.factor())

                Text("비밀번호를\n입력해 주세요")
                    .font(.H1SemiboldFont())
                    .platformTextColor(color: Color("Gray07"))

                Spacer().frame(height: 13 * DynamicSizeFactor.factor())

                Text("비밀번호가 필요한 비공개 채팅방이에요")
                    .font(.H4MediumFont())
                    .platformTextColor(color: Color("Gray04"))

                Spacer().frame(height: 17 * DynamicSizeFactor.factor())
            }
            .padding(.horizontal, 20)

            CustomInputView(inputText: $password, placeholder: "", isSecureText: false)

            Spacer()

            CustomBottomButton(action: {
                isNavigate = true
            }, label: "다음", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())

            NavigationLink(destination: MakeUsernameView(), isActive: $isNavigate) {}
                .hidden()
        }
        .navigationBarColor(UIColor(named: "White01"), title: "배달음식 그만 먹는 방")
        .edgesIgnoringSafeArea(.bottom)
        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    NavigationBackButton()
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())

                }.offset(x: -10)
            }
        }
    }
}

#Preview {
    SecretRoomView()
}
