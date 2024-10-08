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
            Spacer().frame(height: 25 * DynamicSizeFactor.factor())

            LazyVStack(spacing: 14 * DynamicSizeFactor.factor()) {
                ForEach(groupedChatsByDate.keys.sorted(), id: \.self) { date in
                    Section(header: ChatDateHeader(date: date)) {
                        Spacer().frame(height: 7 * DynamicSizeFactor.factor())

                        ForEach(groupedChatsByDate[date] ?? []) { chat in
                            if let sender = members.first(where: { $0.user_id == chat.sender_id }) {
                                if chat.sender_id == currentUserID {
                                    ChatSendCell(chat: chat, sender: sender)
                                } else {
                                    ChatReceiveCell(chat: chat, sender: sender)
                                }
                            }
                        }
                        Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                    }
                }
            }
        }
    }

    private var groupedChatsByDate: [String: [Chat]] {
        let formatter = Date.chatDateFormatter() 
        return Dictionary(grouping: chats) { chat in
            formatter.string(from: chat.created_at)
        }
    }
}
