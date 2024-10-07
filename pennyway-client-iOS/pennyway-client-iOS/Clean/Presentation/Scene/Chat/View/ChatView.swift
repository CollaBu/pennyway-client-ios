//
//  ChatView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

// MARK: - ChatView

struct ChatView: View {
    //    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack(spacing: 0) {
            ChatContent(chats: mockChats, members: mockMembers, currentUserID: 102)
            ChatBottomBar()
        }
        .navigationBarColor(UIColor(named: "Ashblue02"), title: "\(mockChatRoom.title)")
        .background(Color("Ashblue02"))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    NavigationBackButton()
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())

                }.offset(x: -10)
            }
            ToolbarItem(placement: .topBarTrailing) {}
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
        username: "UserOne",
        role: "Admin",
        user_id: 101,
        chat_room_id: 1
    ),
    ChatMember(
        id: 2,
        profile_image: "https://example.com/user2.jpg",
        username: "UserTwo",
        role: "Member",
        user_id: 102,
        chat_room_id: 1
    )
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
        content: "Just working on some SwiftUI stuff.",
        created_at: Date(),
        sender_id: 101,
        chat_room_id: 1
    )
]
