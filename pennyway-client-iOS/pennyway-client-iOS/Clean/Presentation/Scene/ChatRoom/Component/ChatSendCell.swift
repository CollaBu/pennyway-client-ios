//
//  ChatSendCell.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

// MARK: - ChatSendCell

struct ChatSendCell: View {
    let chat: MessageItemModel
    let sender: ChatMemberItemModel

    var body: some View {
        ChatMessage(chat: chat, sender: sender, isSender: true)
            .padding(.horizontal, 20)
    }
}
