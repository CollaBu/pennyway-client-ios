//
//  GetPreviousChatResponseDto.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/12/24.
//

import Foundation

// MARK: - GetPreviousChatResponseDto

struct GetPreviousChatResponseDto: Codable {
    let code: String
    let data: GetPreviousMessage

    struct GetPreviousMessage: Codable {
        let chats: PreviousMessageDto
    }

    struct PreviousMessageDto: Codable {
        let contents: [GetMessage]
        let currentPageNumber: Int
        let pageSize: Int
        let numberOfElements: Int
        let hasNext: Bool
    }

    static func to(dto: GetPreviousChatResponseDto) -> PreviousMessage {
        let messages = dto.data.chats.contents.map { previousMessage in
            Message(
                chatRoomId: previousMessage.chatRoomId,
                chatId: previousMessage.chatId,
                content: previousMessage.content,
                contentType: previousMessage.contentType,
                categoryType: previousMessage.categoryType,
                createdAt: previousMessage.createdAt,
                senderId: previousMessage.senderId
            )
        }

        return PreviousMessage(
            contents: messages,
            currentPageNumber: dto.data.chats.currentPageNumber,
            pageSize: dto.data.chats.pageSize,
            numberOfElements: dto.data.chats.numberOfElements,
            hasNext: dto.data.chats.hasNext
        )
    }
}
