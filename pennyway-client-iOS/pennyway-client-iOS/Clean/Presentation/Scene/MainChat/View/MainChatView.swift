
import SwiftUI

// MARK: - MainChatView

struct MainChatView: View {
    @State private var selectedTab: Int = 1
    @State private var chatRoomName: String = "" // 수정 예정
    @State private var isNavigateToMakeChatRoom = false
    @State private var isCheckMarkVisible = false // 체크 표시를 보여줄지 여부
    @State private var isPopUp = false // 채팅방 나가기 팝업 표시 여부
    @State private var selectedChatRoom: ChatRoom? = nil // 어떤 채팅방이 선택됐는지의 여부
    @State private var dummyChatRooms = [
        ChatRoom(id: 1, title: "배달음식 그만 먹는 방", description: "배달음식 NO 집밥 YES", background_image_url: "icon_notifications", password: "", privacy_setting: false, notify_enabled: true),
        ChatRoom(id: 2, title: "월급 다 쓴 사람이 모인 방", description: "함께 저축해요", background_image_url: "icon_notifications", password: "1234", privacy_setting: true, notify_enabled: true)
    ]
    
    private let maxLength = 19
    
    var body: some View {
        NavigationAvailable {
            ZStack {
                VStack {
                    Spacer().frame(height: 38 * DynamicSizeFactor.factor())
                    HStack(spacing: 30) {
                        Button(action: {
                            selectedTab = 1
                        }, label: {
                            MyChatContainer
                        })
                        Button(action: {
                            selectedTab = 2
                        }, label: {
                            RecommendChatContainer
                        })
                    }
                    
                    Spacer().frame(height: 28 * DynamicSizeFactor.factor())

                    // 내 채팅에서 채팅방의 존재 유무에 따라 다른 뷰를 보여주도록 함
                    if selectedTab == 1 {
                        if dummyChatRooms.isEmpty {
                            DefaultChatContent()
                            Spacer()
                        } else {
                            searchChatContainer
                            ChatRoomContent(isPopUp: $isPopUp, selectedChatRoom: $selectedChatRoom, dummyChatRooms: $dummyChatRooms, isMyChat: true)
                        }
                    } else {
                        searchChatContainer
                        ChatRoomContent(isPopUp: $isPopUp, selectedChatRoom: $selectedChatRoom, dummyChatRooms: $dummyChatRooms, isMyChat: false)
                    }
                    
                    NavigationLink(destination: MakeChatRoomView(), isActive: $isNavigateToMakeChatRoom) {}
                        .hidden()
                }
                
                if isPopUp, let chatRoom = selectedChatRoom {
                    CustomPopUpView(
                        showingPopUp: $isPopUp,
                        titleLabel: "채팅방 나가기",
                        subTitleLabel: "선택한 채팅방에서 나갈까요?",
                        firstBtnAction: { self.isPopUp = false },
                        firstBtnLabel: "취소",
                        secondBtnAction: {
                            withAnimation {
                                self.isPopUp = false // 팝업 닫기
                                showCheckMarkAnimation(chatRoom)
                            }
                        },
                        secondBtnLabel: "나가기",
                        secondBtnColor: Color("Red03"))
                }
                
                if isCheckMarkVisible {
                    Image("icon_illust_completion")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 68 * DynamicSizeFactor.factor(), height: 68 * DynamicSizeFactor.factor())
                }
            }
            .setTabBarVisibility(isHidden: false)
            .navigationTitle(Text("채팅방"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button(action: {
                            isNavigateToMakeChatRoom = true
                        }, label: {
                            Image("icon_navigationbar_mint")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        })
                        .frame(width: 44, height: 44)
                        .buttonStyle(BasicButtonStyleUtil())
                    }
                }
            }
        }
    }
    
    private func showCheckMarkAnimation(_ chatRoom: ChatRoom) {
        withAnimation {
            isCheckMarkVisible = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                isCheckMarkVisible = false
                deleteChatRoom(chatRoom)
            }
        }
    }
    
    /// 채팅방 삭제 함수
    private func deleteChatRoom(_ chatRoom: ChatRoom) {
        dummyChatRooms.removeAll { $0.id == chatRoom.id }
    }
    
    private var searchChatContainer: some View {
        VStack {
            CustomInputView(inputText: $chatRoomName, placeholder: "원하는 주제를 찾아보세요", isSecureText: false, showSearchBtn: true)
                .onChange(of: chatRoomName) { newValue in
                    if newValue.count > maxLength {
                        chatRoomName = String(chatRoomName.suffix(19))
                    }
                }
            Spacer().frame(height: 23 * DynamicSizeFactor.factor())
        }
    }
    
    private var MyChatContainer: some View {
        VStack {
            if selectedTab == 1 {
                ZStack {
                    // TODO: 읽지 않은 채팅이 존재하는 경우에만 Circle이 표시되도록 추후 수정 필요
                    Circle()
                        .platformTextColor(color: Color("Mint03"))
                        .frame(width: 7 * DynamicSizeFactor.factor(), height: 7 * DynamicSizeFactor.factor())
                        .offset(x: 32 * DynamicSizeFactor.factor(), y: -16 * DynamicSizeFactor.factor())
                    VStack {
                        Text("내 채팅")
                            .font(.ButtonH4SemiboldFont())
                            .platformTextColor(color: Color("Mint03"))
                        Capsule()
                            .platformTextColor(color: Color("Mint03"))
                            .frame(width: 106 * DynamicSizeFactor.factor(), height: 3)
                            .padding(.top, 4)
                    }
                }
            } else {
                Text("내 채팅")
                    .font(.ButtonH4SemiboldFont())
                    .platformTextColor(color: Color("Gray07"))
                Capsule()
                    .fill(Color.clear)
                    .frame(width: 106 * DynamicSizeFactor.factor(), height: 3)
                    .padding(.top, 4)
            }
        }
    }
    
    private var RecommendChatContainer: some View {
        VStack {
            if selectedTab == 2 {
                ZStack {
                    VStack {
                        Text("추천 채팅")
                            .font(.ButtonH4SemiboldFont())
                            .platformTextColor(color: Color("Mint03"))
                        Capsule()
                            .platformTextColor(color: Color("Mint03"))
                            .frame(width: 106 * DynamicSizeFactor.factor(), height: 3)
                            .padding(.top, 4)
                    }
                }
            } else {
                Text("추천 채팅")
                    .font(.ButtonH4SemiboldFont())
                    .platformTextColor(color: Color("Gray07"))
                Capsule()
                    .fill(Color.clear)
                    .frame(width: 106 * DynamicSizeFactor.factor(), height: 3)
                    .padding(.top, 4)
            }
        }
    }
}

// MARK: - MainChatViewModelWrapper

final class MainChatViewModelWrapper: ObservableObject {
    @Published var chatData: ChatItemViewModel
    init(chatData: ChatItemViewModel) {
        self.chatData = chatData
    }
}

#Preview {
    MainChatView()
}
