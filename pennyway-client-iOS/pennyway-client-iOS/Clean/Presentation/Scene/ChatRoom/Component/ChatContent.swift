//
//  ChatContent.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import SwiftUI

struct ChatContent: View {
    let chats: [MessageItemModel]
    let members: [ChatMemberItemModel]
    let currentUserId: Int64

    @State private var scrollToBottom: Bool = false
    @ObservedObject var keyboardManager: KeyboardManager

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 14 * DynamicSizeFactor.factor()) {
                    ForEach(groupedChatsByDate.keys.sorted(), id: \.self) { date in
                        Spacer().frame(height: 10 * DynamicSizeFactor.factor())
                        Section(header: ChatHeader(data: date)) {
                            Spacer().frame(height: 3)

                            ForEach(groupedChatsByDate[date] ?? []) { chat in
                                if let sender = members.first(where: { $0.userId == chat.senderId }) {
                                    if chat.senderId == currentUserId {
                                        ChatSendCell(chat: chat, sender: sender)
                                    } else {
                                        ChatReceiveCell(chat: chat, sender: sender)
                                    }
                                } else {
                                    Spacer().frame(height: 3)

                                    if chat.categoryType == CategoryType.system {
                                        ChatHeader(data: chat.content)
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
            .onChange(of: chats) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    proxy.scrollTo("bottom", anchor: .bottom)
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

    private var groupedChatsByDate: [String: [MessageItemModel]] {
        let formatter = Date.chatDateFormatter()
        let grouped = Dictionary(grouping: chats) { chat -> String in
            if let date = DateFormatterUtil.dateFromString(chat.createdAt) {
                return formatter.string(from: date)
            }
            return ""
        }

        // 각 날짜별 메시지 배열을 오래된순으로 저장
        return grouped.mapValues { $0.reversed() }
    }
}
