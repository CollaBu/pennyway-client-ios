//
//  ChatContent.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

struct ChatContent: View {
    let chats: [Chat]
    let members: [ChatMember]
    let currentUserID: Int64 

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14 * DynamicSizeFactor.factor()) {
                ForEach(chats) { chat in
                    if let sender = members.first(where: { $0.user_id == chat.sender_id }) {
                        if chat.sender_id == currentUserID {
                            // Current user is the sender, show ChatSendCell
                            ChatSendCell(chat: chat, sender: sender)
                        } else {
                            // Other user is the sender, show ChatReceiveCell
                            ChatReceiveCell(chat: chat, sender: sender)
                        }
                    }
                }
            }
        }
    }
}
