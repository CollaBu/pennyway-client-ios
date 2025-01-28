//
//  SendChatUseCase.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/7/24.
//

import Foundation

// MARK: - SendChatUseCase

protocol SendChatUseCase {
    func sendMessage(message: String, chatRoomId: Int64, contentType: String, completion: @escaping (Result<Void, Error>) -> Void)
    func sendLastMessage(chatRoomId: Int64, lastReadMessageId: Int64, completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - DefaultSendChatUseCase

class DefaultSendChatUseCase: SendChatUseCase {
    private let chatStompService = DefaultChatStompService.shared

    func sendMessage(message: String, chatRoomId: Int64, contentType: String, completion _: @escaping (Result<Void, Error>) -> Void) {
        chatStompService.sendMessage(message: message, chatRoomId: chatRoomId, contentType: contentType)
    }

    func sendLastMessage(chatRoomId: Int64, lastReadMessageId: Int64, completion _: @escaping (Result<Void, Error>) -> Void) {
        chatStompService.sendLastMessage(chatRoomId: chatRoomId, lastReadMessageId: lastReadMessageId)
    }
}
