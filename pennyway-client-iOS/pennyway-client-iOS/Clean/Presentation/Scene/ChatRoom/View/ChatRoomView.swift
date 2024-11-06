//
//  ChatRoomView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

// MARK: - ChatRoomView

struct ChatRoomView: View {
    @StateObject private var keyboardManager = KeyboardManager()
    @State private var isSideMenuPresented = false
    @EnvironmentObject var viewStateManager: ViewStateManager
    @EnvironmentObject var viewModelWrapper: ChatRoomViewModelWrapper

    var chatRoom: ChatRoomItemModel

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    ChatContent(chats: viewModelWrapper.messageData, members: mockMembers, currentUserId: 102, keyboardManager: keyboardManager)
                        .frame(height: geometry.size.height - keyboardManager.keyboardHeight) // ChatContent의 높이를 키보드 높이만큼 조정
                }

                ChatBottomBar()
                    .offset(y: -keyboardManager.keyboardHeight)
                    .animation(keyboardManager.keyboardHeight > 0 ? .easeOut(duration: 0.5) : nil, value: keyboardManager.keyboardHeight)
            }
            .navigationBarColor(UIColor(named: "Ashblue02"), title: "\(chatRoom.title)")
            .background(Color("Ashblue02"))
            .setTabBarVisibility(isHidden: true)
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.bottom)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        NavigationBackButton()
                            .padding(.leading, 5)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }.offset(x: -10)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button(action: {
                            withAnimation {
                                isSideMenuPresented.toggle()
                            }
                        }, label: {
                            Image("icon_navigationbar_kebabmenu")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                .padding(5)
                        })
                        .padding(.trailing, 5)
                        .frame(width: 44, height: 44)
                        .buttonStyle(BasicButtonStyleUtil())
                    }.offset(x: 10)
                }
            }
            .overlay(
                Group {
                    if isSideMenuPresented {
                        ChatSideMenuView(isPresented: $isSideMenuPresented)
                            .transition(.move(edge: .trailing))
                    }
                }
            )
            .onAppear {
                viewStateManager.setCurrentView(self)

                // 채팅방 상세 정보 조회
                viewModelWrapper.chatRoomViewModel.getChatRoomDetail(chatRoomId: chatRoom.id)
            }
        }
    }
}

// MARK: - ChatRoomViewModelWrapper

final class ChatRoomViewModelWrapper: ObservableObject {
    @Published var roomDetailData: ChatRoomDetailItemModel? = nil
    @Published var messageData: [MessageItemModel] = []
    @Published var chatUserData: [ChatUserInfoItemModel] = []

    var chatRoomViewModel: any ChatRoomViewModel

    init(chatRoomViewModel: any ChatRoomViewModel) {
        self.chatRoomViewModel = chatRoomViewModel

        roomDetailData = chatRoomViewModel.roomDetailData.value
        messageData = chatRoomViewModel.messageData.value
        chatUserData = chatRoomViewModel.chatUserData.value

        chatRoomViewModel.roomDetailData.observe(on: self) { [weak self] newData in
            self?.roomDetailData = newData
        }

        chatRoomViewModel.messageData.observe(on: self) { [weak self] newData in
            self?.messageData = newData
        }

        chatRoomViewModel.chatUserData.observe(on: self) { [weak self] newData in
            self?.chatUserData = newData
        }
    }
}

let mockChatRoom = ChatRoom(
    id: 1,
    title: "SwiftUI Chat Room",
    description: "A place to talk about SwiftUI",
    background_image_url: "https://example.com/background.jpg",
    isPrivate: true,
    isAdmin: true,
    participantCount: 0,
    createdAt: "2024-10-25T06:09:41.472Z",
    unreadMessageCount: 0
)

let mockMembers: [ChatMember] = [
    ChatMember(
        id: 1,
        profile_image: "https://example.com/user1.jpg",
        username: "바다오리",
        role: "Member",
        user_id: 101,
        chat_room_id: 1
    ),
    ChatMember(
        id: 2,
        profile_image: "https://example.com/user2.jpg",
        username: "고래고래고래",
        role: "Admin",
        user_id: 102,
        chat_room_id: 1
    ),
]

let mockChats: [MessageItemModel] = [
    MessageItemModel(
        chatRoomId: 1,
        chatId: 1,
        content: "Hey, how's it going?",
        contentType: .text,
        categoryType: .normal,
        createdAt: "2024-9-04 19:46:19",
        senderId: 101
    ),
    MessageItemModel(
        chatRoomId: 1,
        chatId: 2,
        content: "All good here! How about you?",
        contentType: .text,
        categoryType: .normal,
        createdAt: "2024-9-04 19:46:19",
        senderId: 102
    ),
    MessageItemModel(
        chatRoomId: 1,
        chatId: 3,
        content: "안녕하세요안녕하세요",
        contentType: .text,
        categoryType: .normal,
        createdAt: "2024-9-04 19:46:19",
        senderId: 101
    ),
    MessageItemModel(
        chatRoomId: 1,
        chatId: 4,
        content: "Just working on some SwiftUI stuff.",
        contentType: .text,
        categoryType: .normal,
        createdAt: "2024-9-04 19:46:19",
        senderId: 101
    ),
    MessageItemModel(
        chatRoomId: 1,
        chatId: 5,
        content: "Just working on some SwiftUI stuff.",
        contentType: .text,
        categoryType: .normal,
        createdAt: "2024-10-21 19:46:19",
        senderId: 102
    ),
    MessageItemModel(
        chatRoomId: 1,
        chatId: 6,
        content: "Just working on some SwiftUI stuff.",
        contentType: .text,
        categoryType: .normal,
        createdAt: "2024-10-21 19:46:19",
        senderId: 102
    ),
    MessageItemModel(
        chatRoomId: 1,
        chatId: 7,
        content: "Just working on some SwiftUI stuff.",
        contentType: .text,
        categoryType: .normal,
        createdAt: "2024-11-5 19:46:19",
        senderId: 102
    ),
    MessageItemModel(
        chatRoomId: 1,
        chatId: 8,
        content: "Just working on some SwiftUI stuff.",
        contentType: .text,
        categoryType: .normal,
        createdAt: "2024-11-5 19:46:19",
        senderId: 101
    ),
]
