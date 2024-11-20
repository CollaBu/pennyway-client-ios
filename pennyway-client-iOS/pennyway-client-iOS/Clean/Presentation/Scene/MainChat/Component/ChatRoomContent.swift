import SwiftUI

// MARK: - ChatRoomContent

struct ChatRoomContent: View {
    @Binding var isNavigateChatRoomDetailView: Bool // 채팅방 가입 뷰로 이동하기 위한 변수
    @Binding var isPopUp: Bool // 채팅방 나가기 팝업 표시 여부
    @Binding var selectedChatRoom: ChatRoomItemModel? // 내 채팅 중 선택된 채팅방을 저장하기 위한 변수
    @Binding var selectedSearchChatRoom: SearchChatRoomItemModel? // 추천 채팅 중 선택된 채팅방을 저장하기 위한 변수
    @Binding var dummyChatRooms: [ChatRoomItemModel]? // 내 채팅의 item을 표시하기 위한 항목
    var searchChatRooms: [SearchChatRoomItemModel]? // 추천 채팅 item을 표시하기 위한 항목
    var isMyChat: Bool // 내 채팅 여부
    let target: String // 채팅방 검색어를 나타내는 항목
    @ObservedObject var viewModelWrapper: ChatViewModelWrapper

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if isMyChat {
                    if let rooms = dummyChatRooms {
                        ForEach(rooms, id: \.id) { chatRoom in
                            NavigationLink(destination: ChatRoomView(chatViewModelWrapper: viewModelWrapper, chatRoom: chatRoom)) {
                                ChatRoomCell(chatRoom: chatRoom, isMyChat: true, onDelete: {
                                    isPopUp = true
                                    selectedChatRoom = chatRoom
                                })
                            }
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                        }
                    }
                } else {
                    if let rooms = searchChatRooms {
                        ForEach(rooms, id: \.id) { chatRoom in
                            Button(action: {
                                selectedSearchChatRoom = chatRoom
                                isNavigateChatRoomDetailView = true
                            }, label: {
                                ChatRoomCell(chatRoom: chatRoom, isMyChat: false, onDelete: {
                                    isPopUp = true
                                })
                                .contentShape(Rectangle())
                                .onAppear {
                                    guard let index = rooms.firstIndex(where: { $0.id == chatRoom.id }) else {
                                        return
                                    }
                                    // 현재 항목이 마지막 인덱스에 도달했을 때만 API 호출
                                    if index == rooms.count - 1, viewModelWrapper.getChatRoomViewModel.hasNext, !viewModelWrapper.getChatRoomViewModel.isFetching {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                            viewModelWrapper.getChatRoomViewModel.searchChatRoom(target: target)
                                        }
                                    }
                                }
                                
                            })
                        }
                    }
                }
            }
        }
    }
}

// MARK: - ChatRoomCell

struct ChatRoomCell: View, ImageLoadable {
    @State private var loadedImage: UIImage? = nil

    let chatRoom: ChatRoomProtocol
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
                            Image("icon_chat_delete_line_white")
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
                if let image = loadedImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 43 * DynamicSizeFactor.factor(), height: 43 * DynamicSizeFactor.factor())
                        .cornerRadius(8)
                } else {
                    Image("icon_illust_chat_no picture")
                        .resizable()
                        .frame(width: 43 * DynamicSizeFactor.factor(), height: 43 * DynamicSizeFactor.factor())
                        .cornerRadius(8)
                }
                    
                ZStack {
                    VStack(alignment: .leading) {
                        HStack(spacing: 4 * DynamicSizeFactor.factor()) {
                            Text(chatRoom.title)
                                .font(.B1SemiboldeFont())
                                .platformTextColor(color: Color("Gray07"))
                                
                            if chatRoom.isPrivate {
                                Image("icon_lock")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 9 * DynamicSizeFactor.factor(), height: 11.3 * DynamicSizeFactor.factor())
                                    .platformTextColor(color: Color("Gray04"))
                            }
                                
                            if isMyChat {
                                Spacer()
                                // TODO: 채팅방에 마지막으로 접속한 날짜 -> 웹 소켓 연결 후 수정 필요
                                VStack(alignment: .trailing) {
                                    Text(DateFormatterUtil.formatRelativeDate(from: chatRoom.lastMassage?.createdAt ?? ""))
                                        .font(.B3MediumFont())
                                        .platformTextColor(color: Color("Gray04"))
                                }
                            }
                        }
                            
                        Spacer().frame(height: 4 * DynamicSizeFactor.factor())
                            
                        // 내 채팅인 경우 categoryType이 NORMAL인 경우만 뷰에 표시되도록 함
                        if isMyChat {
                            Text(chatRoom.lastMassage?.categoryType == CategoryType.normal ? chatRoom.lastMassage?.content ?? "" : "")
                                .font(.B3MediumFont())
                                .platformTextColor(color: Color("Gray07"))
                        } else {
                            Text(chatRoom.description)
                                .font(.B3MediumFont())
                                .platformTextColor(color: Color("Gray07"))
                        }
                            
                        Spacer().frame(height: 3 * DynamicSizeFactor.factor())
                        
                        Text("\(chatRoom.participantCount)명")
                            .font(.B3MediumFont())
                            .platformTextColor(color: Color("Gray04"))
                            .padding(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                        
                    if isMyChat {
                        if chatRoom.unreadMessageCount > 0 {
                            ZStack {
                                Text("\(chatRoom.unreadMessageCount)")
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
        .onAppear {
            loadImage(from: chatRoom.backgroundImageUrl) { image in
                self.loadedImage = image
            }
        }
    }
}
