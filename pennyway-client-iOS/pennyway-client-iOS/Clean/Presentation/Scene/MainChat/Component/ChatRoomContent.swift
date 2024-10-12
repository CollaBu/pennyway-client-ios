import SwiftUI

// MARK: - ChatRoomContent

struct ChatRoomContent: View {
    @Binding var isPopUp: Bool // 채팅방 나가기 팝업 표시 여부
    @Binding var selectedChatRoom: ChatRoom? // 선택된 채팅방을 저장하기 위한 변수
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
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
        }
    }
}

// MARK: - ChatRoomCell

struct ChatRoomCell: View {
    let chatRoom: ChatRoom
    let isMyChat: Bool
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0 // 삭제 버튼의 위치를 조절해주는 offset값
    @State private var isShowingDeleteButton = false // 삭제 버튼의 표시 여부
    
    var body: some View {
        ZStack {
            // 내 채팅인 경우에만 삭제 버튼이 동작해야 함
            if isMyChat {
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
            }
            // 채팅방 셀
            HStack(spacing: 13) {
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
                                Image("icon_lock")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 9 * DynamicSizeFactor.factor(), height: 11.3 * DynamicSizeFactor.factor())
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
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation {
                            if value.translation.width < 0, isMyChat { // 내 채팅방일 때만 스와이프 가능
                                offset = max(value.translation.width, -90)
                                isShowingDeleteButton = true
                            } else {
                                offset = 0
                                isShowingDeleteButton = false
                            }
                        }
                    }
                    .onEnded { value in
                        withAnimation {
                            if value.translation.width < -80, isMyChat {
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
