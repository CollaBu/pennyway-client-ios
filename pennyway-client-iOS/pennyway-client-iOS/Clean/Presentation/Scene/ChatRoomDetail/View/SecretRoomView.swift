
import SwiftUI

struct SecretRoomView: View {
    let chatRoom: SearchChatRoomItemModel?
    let chatRoomId: Int64
    @State private var password = ""
    @State private var isPasswordMatch = false // 비밀번호 일치 여부를 관리하는 변수
    @State private var isNavigateToChatRoom = false
    @State private var isFirstAttempt = true

    @ObservedObject var viewModelWrapper: ChatViewModelWrapper

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Spacer().frame(height: 36 * DynamicSizeFactor.factor())

                Text("비밀번호를\n입력해주세요")
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
                viewModelWrapper.joinChatRoomViewModel.validatePwForm(password: password)
            }, isSecureText: false)
                .keyboardType(.numberPad)
                .onChange(of: password) { _ in
                    if password.count > 6 {
                        password = String(password.prefix(6))
                    }
                    viewModelWrapper.joinChatRoomViewModel.validatePwForm(password: password)
                    if !password.isEmpty {
                        isPasswordMatch = false
                    }
                }
                .onChange(of: isPasswordMatch) { _ in
                    password = ""
                }

            if isPasswordMatch {
                Spacer().frame(height: 12)

                Text("비밀번호가 잘못 입력되었어요")
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Red03"))
                    .padding(.horizontal, 20)
            }
            Spacer()

            CustomBottomButton(action: {
                if viewModelWrapper.joinChatRoomViewModel.isFormValid {
                    viewModelWrapper.joinChatRoomViewModel.joinChatRoom(chatRoomId: chatRoomId, password: password) { success in
                        if success {
                            Log.debug("[SecretRoomView]: 채팅방 가입 성공")
                            isNavigateToChatRoom = true
                        } else {
                            if viewModelWrapper.joinChatRoomViewModel.isPasswordInvalid {
                                isPasswordMatch = true
                            }
                            Log.debug("[SecretRoomView]: 채팅방 가입 실패")
                        }
                    }
                }
            }, label: "채팅 참여하기", isFormValid: $viewModelWrapper.joinChatRoomViewModel.isFormValid)
                .padding(.bottom, 34 * DynamicSizeFactor.factor())

            NavigationLink(
                destination: ChatRoomView(chatViewModelWrapper: viewModelWrapper),
                isActive: $isNavigateToChatRoom
            ) {}
                .hidden()
        }
        .navigationBarColor(UIColor(named: "White01"), title: "\(chatRoom?.title ?? "")")
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
