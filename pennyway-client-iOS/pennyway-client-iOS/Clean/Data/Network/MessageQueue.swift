//
//  MessageQueue.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/23/25.
//

import BTree
import Combine
import Foundation

// MARK: - MessageQueue

final class MessageQueue {
    // MARK: - Properties
    
    static let shared = MessageQueue()
    private var messages = BTree<String, SocketMessage>()
    private var isAuthUpdating = false
    private let stompClient: CustomStompClient
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialize
    
    private init(stompClient: CustomStompClient = .shared) {
        self.stompClient = stompClient
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAuthStart),
            name: .socketAuthStart,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAuthUnlock),
            name: .socketAuthUnlock,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRemoveMessage),
            name: .successSendMessage,
            object: nil
        )
    }
    
    // MARK: - Public Methods
    
    func enqueue(message: SocketMessage, id: String) {
        messages.insert((id, message))
        
        if !isAuthUpdating {
            sendMessage(message, id: id)
        }
    }
    
    func markSuccess(messageId: String) {
        if let index = messages.index(forKey: messageId) {
            messages.remove(at: index)
        }
        
        // 만약 성공 처리 후 큐에 메시지가 남아있고, 인증 갱신 중이 아니라면 다음 메시지 전송
        if !isAuthUpdating, let oldest = getOldestMessage() {
            sendMessage(oldest.message, id: oldest.id)
        }
    }
    
    // MARK: - Private Methods
    
    private func sendMessage(_ message: SocketMessage, id: String) {
        let headers = [
            "Authorization": "Bearer \(KeychainHelper.loadAccessToken() ?? "")",
            "content-type": "application/json",
            "x-message-id": id
        ]
        
        stompClient.sendMessage(
            message: message.content,
            destination: message.destination,
            headers: headers, 
            contentType: message.contentType
        )
    }
    
    private func getOldestMessage() -> (id: String, message: SocketMessage)? {
        guard let first = messages.first else {
            return nil
        }
        return (first.0, first.1)
    }
    
    private func processPendingMessages() {
        while !isAuthUpdating, let oldest = getOldestMessage() {
            sendMessage(oldest.message, id: oldest.id)
            
            if let index = messages.index(forKey: oldest.id) {
                messages.remove(at: index)
            }
        }
    }
    
    // MARK: - Notification Handlers
    
    @objc private func handleAuthStart() {
        isAuthUpdating = true
    }
    
    @objc private func handleAuthUnlock() {
        isAuthUpdating = false
        processPendingMessages()
    }
    
    @objc func handleRemoveMessage(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let messageId = userInfo["messageId"] as? String else { return }

        if let index = messages.index(forKey: messageId) {
            messages.remove(at: index)
            Log.debug("[✅ Remove Message] - messageId: \(messageId)")
        }
    }
}

