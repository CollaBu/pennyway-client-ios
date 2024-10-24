//
//  ChatView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

// MARK: - ChatView

struct ChatView: View {
    @StateObject private var keyboardManager = KeyboardManager()
    @State private var isSideMenuPresented = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    ChatContent(chats: mockChats, members: mockMembers, currentUserId: 102, keyboardManager: keyboardManager)
                        .frame(height: geometry.size.height - keyboardManager.keyboardHeight) // ChatContent의 높이를 키보드 높이만큼 조정
                }

                ChatBottomBar()
                    .offset(y: -keyboardManager.keyboardHeight)
                    .animation(keyboardManager.keyboardHeight > 0 ? .easeOut(duration: 0.5) : nil, value: keyboardManager.keyboardHeight)
            }
            .navigationBarColor(UIColor(named: "Ashblue02"), title: "\(mockChatRoom.title)")
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
//            .background(
//                if isSideMenuPresented {
//                    Color.black.opacity(0.3)
//                        .edgesIgnoringSafeArea(.all)
            ////                        .onTapGesture {
            ////                            withAnimation {
            ////                                isPresented = false
            ////                            }
            ////                        }
//                }
//            )
        }
    }
}

#Preview {
    ChatView()
}

let mockChatRoom = ChatRoom(
    id: 1,
    title: "SwiftUI Chat Room",
    description: "A place to talk about SwiftUI",
    background_image_url: "https://example.com/background.jpg",
    password: nil,
    privacy_setting: true,
    notify_enabled: true
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

let mockChats: [Chat] = [
    Chat(
        id: 1,
        content: "Hey, how's it going?",
        created_at: Date(),
        sender_id: 101,
        chat_room_id: 1
    ),
    Chat(
        id: 2,
        content: "All good here! How about you?",
        created_at: Date(),
        sender_id: 102,
        chat_room_id: 1
    ),
    Chat(
        id: 3,
        content: "안녕하세요안녕하세요",
        created_at: Date(),
        sender_id: 101,
        chat_room_id: 1
    ),

    Chat(
        id: 4,
        content: "Just working on some SwiftUI stuff.",
        created_at: Date(),
        sender_id: 101,
        chat_room_id: 1
    ),
    Chat(
        id: 5,
        content: "Just working on some SwiftUI stuff.",
        created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 21))!,
        sender_id: 102,
        chat_room_id: 1
    ),
    Chat(
        id: 6,
        content: "Just working on some SwiftUI stuff.",
        created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 21))!,
        sender_id: 102,
        chat_room_id: 1
    ),
    Chat(
        id: 7,
        content: "Just working on some SwiftUI stuff.",
        created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 21))!,
        sender_id: 102,
        chat_room_id: 1
    ),
    Chat(
        id: 8,
        content: "Just working on some SwiftUI stuff.",
        created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 21))!,
        sender_id: 101,
        chat_room_id: 1
    ),
]
