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
    let currentUserId: Int64

    @State private var scrollToBottom: Bool = false
    @ObservedObject var keyboardManager: KeyboardManager

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 14 * DynamicSizeFactor.factor()) {
                    ForEach(groupedChatsByDate.keys.sorted(), id: \.self) { date in
                        Spacer().frame(height: 10 * DynamicSizeFactor.factor())
                        Section(header: ChatDateHeader(date: date)) {
                            Spacer().frame(height: 5 * DynamicSizeFactor.factor())

                            ForEach(groupedChatsByDate[date] ?? []) { chat in
                                if let sender = members.first(where: { $0.user_id == chat.sender_id }) {
                                    if chat.sender_id == currentUserId {
                                        ChatSendCell(chat: chat, sender: sender)
                                    } else {
                                        ChatReceiveCell(chat: chat, sender: sender)
                                    }
                                }
                            }
                        }
                    }

                    // ScrollView 하단에 있는 마지막 아이템을 위한 태그
                    Spacer().frame(height: 5 * DynamicSizeFactor.factor())
                        .id("bottom")
                }
            }
            .onChange(of: keyboardManager.keyboardHeight) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    proxy.scrollTo("bottom", anchor: .bottom)
                }
            }.onAppear {
                // 처음 열릴 때 가장 아래로 스크롤
                proxy.scrollTo("bottom", anchor: .bottom)
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
