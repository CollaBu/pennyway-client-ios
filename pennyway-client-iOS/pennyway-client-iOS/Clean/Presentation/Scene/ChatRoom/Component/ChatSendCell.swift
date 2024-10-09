//
//  ChatSendCell.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

// MARK: - ChatSendCell

struct ChatSendCell: View {
    let chat: Chat
    let sender: ChatMember

    var body: some View {
        ChatMessage(content: chat.content, createdAt: chat.created_at, isSender: true)
            .padding(.horizontal, 20)
    }
}
