
import SwiftUI

// MARK: - MakeUsernameView

struct MakeUsernameView: View {
    let chatRoomId: Int64
    let password: String
    @State private var username = ""
    @State private var isNavigate = false

    @ObservedObject var viewModelWrapper: ChatViewModelWrapper

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Spacer().frame(height: 36 * DynamicSizeFactor.factor())

                Text("어떤 이름으로\n참여할까요?")
                    .font(.H1SemiboldFont())
                    .platformTextColor(color: Color("Gray07"))

                Spacer().frame(height: 13 * DynamicSizeFactor.factor())

                Text("채팅방에서 사용할 닉네임을 작성해주세요")
                    .font(.H4MediumFont())
                    .platformTextColor(color: Color("Gray04"))

                Spacer().frame(height: 17 * DynamicSizeFactor.factor())
            }
            .padding(.horizontal, 20)

            CustomInputView(inputText: $username, placeholder: "", onCommit: {
                viewModelWrapper.joinChatRoomViewModel.validateName(name: username)
            }, isSecureText: false)
                .onChange(of: username) { _ in
                    if username.count > 8 {
                        username = String(username.prefix(8))
                    }
                    viewModelWrapper.joinChatRoomViewModel.validateName(name: username)
                }

            Spacer()

            CustomBottomButton(action: {
                if viewModelWrapper.joinChatRoomViewModel.isFormValid {
                    Log.debug("[MakeUsernameView]: isFormValid까지 통과")
                    viewModelWrapper.joinChatRoomViewModel.joinChatRoom(chatRoomId: chatRoomId, password: password) { success in
                        if success {
                            Log.debug("[MakeUsernameView]: 채팅방 가입 성공")
                        } else {
                            Log.debug("[MakeUsernameView]: 채팅방 가입 실패")
                        }
                    }
                }
            }, label: "채팅 참여하기", isFormValid: $viewModelWrapper.joinChatRoomViewModel.isFormValid)
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        .navigationBarColor(UIColor(named: "White01"), title: "프로필 설정")
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
        .onAppear {
            Log.debug("[MakeUserNameView]: chatRoomId-\(chatRoomId), password-\(password)")
        }
    }
}
