//
//  ChatStompUseCase.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/16/24.
//

import Combine
import StompClientLib
import SwiftUI

// MARK: - ChatStompService

protocol ChatStompService {
    func connect()
    func disconnect()
    func sendMessage(message: String, destination: String)
    func subscribeToDestination(_ destination: String)
}

// MARK: - DefaultChatStompService

class DefaultChatStompService: ChatStompService {
    static let shared = DefaultChatStompService()
    
    private let repository: ChatStompRepository
    
    private init() {
        repository = DefaultChatStompRepository(stompClient: StompClientLib())
    }
    
    func connect() {
        repository.connect { result in
            switch result {
            case .success:
                self.subscribeToChat()
                self.subscribeToErrors()
            case let .failure(error):
                Log.error("Failed to connect: \(error)")
            }
        }
    }
    
    func disconnect() {
        repository.disconnect()
    }
    
    func sendMessage(message: String, destination: String) {
        repository.sendMessage(message: message, destination: destination)
    }
    
    func subscribeToDestination(_ destination: String) {
        repository.subscribeToDestination(destination)
    }
    
    private func subscribeToChat() {
        subscribeToDestination("/sub/chat.room.1")
    }
    
    private func subscribeToErrors() {
        subscribeToDestination("/user/queue/errors")
    }
}
