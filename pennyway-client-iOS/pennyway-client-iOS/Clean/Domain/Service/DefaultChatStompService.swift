//
//  ChatStompUseCase.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/16/24.
//

import Combine
import StompClientLib
import SwiftUI

// MARK: - DefaultChatStompService

class DefaultChatStompService {
    static let shared = DefaultChatStompService()
    
    private let repository: ChatStompRepository
    
    private init() {
        repository = DefaultChatStompRepository(stompClient: CustomStompClient.shared)
    }
    
    func connect() {
        repository.connect()
    }
    
    func disconnect() {
        repository.disconnect()
    }
    
    func sendMessage(message: String, chatRoomId: Int64, contentType: String) {
        repository.sendMessage(message: message, chatRoomId: chatRoomId, contentType: contentType)
    }
    
    func sendLastMessage(chatRoomId: Int64, lastReadMessageId: Int64) {
        repository.sendLastMessage(chatRoomId: chatRoomId, lastReadMessageId: lastReadMessageId)
    }
    
    func subscribeToChatRoom(chatRoomId: Int64) {
        repository.subscribeToChatRoom(chatRoomId: chatRoomId)
    }
    
    func sendViewState(status: String, chatRoomId: Int64?) {
        repository.sendViewState(status: status, chatRoomId: chatRoomId)
    }
}
