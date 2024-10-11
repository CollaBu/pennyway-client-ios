import SwiftUI

// MARK: - ChatRoomContent

struct ChatRoomContent: View {
    @Binding var isPopUp: Bool // 채팅방 나가기 팝업 표시 여부
    @Binding var selectedChatRoom: ChatRoom? // 선택된 채팅방을 저장하기 위한 변수 
//    @State private var dummyChatRooms = [
//        ChatRoom(id: 1, title: "배달음식 그만 먹는 방", description: "배달음식 NO 집밥 YES", background_image_url: "icon_close_filled_primary", password: "", privacy_setting: false, notify_enabled: true),
//        ChatRoom(id: 2, title: "월급 다 쓴 사람이 모인 방", description: "함께 저축해요", background_image_url: "icon_close_filled_primary", password: "1234", privacy_setting: true, notify_enabled: true)
//    ]
    @Binding var dummyChatRooms: [ChatRoom]
    var isMyChat: Bool // 내 채팅 여부

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(dummyChatRooms) { chatRoom in
                    ChatRoomCell(chatRoom: chatRoom, isMyChat: isMyChat, onDelete: {
                        isPopUp = true
                        selectedChatRoom = chatRoom
                    })
                }
            }
        }
    }

//    /// 채팅방 삭제 함수
//    private func deleteChatRoom(_ chatRoom: ChatRoom) {
//        dummyChatRooms.removeAll { $0.id == chatRoom.id }
//    }
}

// MARK: - ChatRoomCell

struct ChatRoomCell: View {
    let chatRoom: ChatRoom
    let isMyChat: Bool
    let onDelete: () -> Void

    @State private var offset: CGFloat = 0
    @State private var isShowingDeleteButton = false

    var body: some View {
        ZStack {
            // 삭제 버튼
            HStack {
                Spacer()
                Button(action: {
                    onDelete()
                }, label: {
                    VStack {
                        Image("icon_chat_delete_line")
                            .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())

                        Text("나가기")
                            .font(.B3MediumFont())
                            .platformTextColor(color: Color("White01"))
                            .padding(1)
                    }
                    .frame(width: 82 * DynamicSizeFactor.factor(), height: 60 * DynamicSizeFactor.factor())
                    .background(Color("Red03"))

                })
            }

            // 채팅방 셀
            HStack {
                Image(chatRoom.background_image_url)
                    .resizable()
                    .frame(width: 43 * DynamicSizeFactor.factor(), height: 43 * DynamicSizeFactor.factor())
                    .cornerRadius(8)

                ZStack {
                    VStack(alignment: .leading) {
                        HStack(spacing: 4 * DynamicSizeFactor.factor()) {
                            Text(chatRoom.title)
                                .font(.B1SemiboldeFont())
                                .platformTextColor(color: Color("Gray07"))

                            if chatRoom.privacy_setting {
                                Image(systemName: "lock.fill")
                                    .platformTextColor(color: Color("Gray04"))
                            }

                            if isMyChat {
                                Spacer()

                                VStack(alignment: .trailing) {
                                    Text("어제")
                                        .font(.B3MediumFont())
                                        .platformTextColor(color: Color("Gray04"))
                                }
                            }
                        }

                        Spacer().frame(height: 4 * DynamicSizeFactor.factor())

                        Text(chatRoom.description)
                            .font(.B3MediumFont())
                            .platformTextColor(color: Color("Gray07"))

                        Spacer().frame(height: 3 * DynamicSizeFactor.factor())

                        Text("127명")
                            .font(.B3MediumFont())
                            .platformTextColor(color: Color("Gray04"))
                            .padding(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    if isMyChat {
                        if chatRoom.notify_enabled {
                            ZStack {
                                Text("24")
                                    .font(.B3MediumFont())
                                    .platformTextColor(color: Color("White01"))
                                    .padding(.vertical, 3 * DynamicSizeFactor.factor())
                                    .padding(.horizontal, 4 * DynamicSizeFactor.factor())
                                    .background(Rectangle()
                                        .cornerRadius(12)
                                        .platformTextColor(color: Color("Mint03")))
                            }
                            .offset(x: 105 * DynamicSizeFactor.factor(), y: 10 * DynamicSizeFactor.factor())
                        }
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: 60 * DynamicSizeFactor.factor())
            .background(Color.white)
//                .cornerRadius(8)
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation {
                            if value.translation.width < 0 {
                                // 왼쪽으로 스와이프
                                offset = value.translation.width
                                isShowingDeleteButton = true
                            } else {
                                // 오른쪽으로 스와이프하면 삭제 버튼 숨김
                                offset = 0
                                isShowingDeleteButton = false
                            }
                        }
                    }
                    .onEnded { value in
                        withAnimation {
                            if value.translation.width < -80 {
                                // 스와이프가 80pt 이상이면 삭제 버튼 표시
                                offset = -90 * DynamicSizeFactor.factor()
                            } else {
                                // 그렇지 않으면 원래 위치로 복구
                                offset = 0
                            }
                        }
                    }
            )
        }
    }
}
