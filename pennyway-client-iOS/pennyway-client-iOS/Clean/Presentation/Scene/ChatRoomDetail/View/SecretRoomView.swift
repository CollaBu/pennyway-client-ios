
import SwiftUI

struct SecretRoomView: View {
    @State private var password = ""
    @State private var isNavigate = false
//    @State private var isFormValid: Bool = false // 뷰모델에서 isFormValid를 받아와 뷰에서 사용하는 변수

    @ObservedObject var viewModelWrapper: ChatViewModelWrapper

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

            CustomInputView(inputText: $password, placeholder: "", onCommit: {
                viewModelWrapper.makeChatViewModel.validatePwForm(password: password)
            }, isSecureText: false)
                .onChange(of: password) { _ in
                    if password.count > 6 {
                        password = String(password.prefix(30))
                    }
                    viewModelWrapper.makeChatViewModel.validatePwForm(password: password)
                }

            Spacer()

            CustomBottomButton(action: {
                if viewModelWrapper.makeChatViewModel.isFormValid {
                    isNavigate = true
                }
            }, label: "다음", isFormValid: $viewModelWrapper.makeChatViewModel.isFormValid)
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
//        .onChange(of: password) { newValue in
//            Log.debug("onChange 실행 됨 ")
//            isFormValid = newValue
//        }
    }
}
