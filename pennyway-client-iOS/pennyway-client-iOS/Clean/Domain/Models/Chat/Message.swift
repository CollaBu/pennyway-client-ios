//
//  Message.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import Foundation

// MARK: - Message

struct Message: Equatable {
    let chatRoomId: Int64
    let chatId: Int64
    let content: String
    let contentType: ContentType
    let categoryType: CategoryType
    let createdAt: String
    let senderId: Int64
}

// MARK: - PreviousMessage

struct PreviousMessage: Equatable {
    let contents: [Message]
    let currentPageNumber: Int
    let pageSize: Int
    let numberOfElements: Int
    let hasNext: Bool

    static func to(model: PreviousMessage) -> [MessageItemModel] {
        return model.contents.map { message in
            MessageItemModel(
                chatRoomId: message.chatRoomId,
                chatId: message.chatId,
                content: message.content,
                contentType: message.contentType,
                categoryType: message.categoryType,
                createdAt: message.createdAt,
                senderId: message.senderId
            )
        }
    }
}
