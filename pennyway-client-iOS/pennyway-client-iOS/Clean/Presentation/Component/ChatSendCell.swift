//
//  ChatSendCell.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

struct ChatSendCell: View {
    let chat: Chat
    let sender: ChatMember

    var body: some View {
        ChatMessage(content: chat.content, createdAt: chat.created_at, isSender: true)
            .padding(.horizontal, 20)
    }
}

#Preview {
    ChatSendCell(chat: Chat(id: 1, content: "ㅎㅇㄹㅇㄹㅇㄹㅇㄹㅇㄹㅇㄹㅇsdfsfsdfsfsfssfㅣㅇㅁㅇㅁ네메냉메ㅐㅏㅇ매안메ㅐasldkalskdkaldk", created_at: Date(), sender_id: 1, chat_room_id: 1), sender: ChatMember(id: 1, profile_image: "", username: "하하하dfdf하하", role: "방장", user_id: 1, chat_room_id: 1))
}
