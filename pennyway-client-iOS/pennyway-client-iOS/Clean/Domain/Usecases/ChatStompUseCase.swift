//
//  ChatStompUseCase.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/16/24.
//

import Combine
import StompClientLib
import SwiftUI

// MARK: - ChatStompUseCase

protocol ChatStompUseCase {
    func connect()
    func disconnect()
    func sendMessage(roomId: String, content: String)
    var isConnected: Bool { get }
    var messages: [Chat] { get }
}

// MARK: - DefaultChatStompUseCase

class DefaultChatStompUseCase: ChatStompUseCase {
    private let repository: ChatStompRepository
    private let stompClient: StompClientLib
    private var socketClient: StompClientLib?
    private var chatServerUrl: String?
    
    @Published private(set) var isConnected: Bool = false
    @Published private(set) var messages: [Chat] = []
    
    init(repository: ChatStompRepository, stompClient: StompClientLib) {
        self.repository = repository
        self.stompClient = stompClient
    }
    
    func connect() {
        repository.getChatServer { [weak self] result in
            switch result {
            case let .success(url):
                self?.chatServerUrl = url
                self?.connectToSocket()
            case let .failure(error):
                Log.error("Failed to get chat server URL: \(error)")
            }
        }
    }
    
    private func connectToSocket() {
        guard let url = chatServerUrl else {
            return
        }
        
        Log.debug("[DefaultChatStompUseCase] connectToSocket()")
        
        let accessToken = KeychainHelper.loadAccessToken() ?? ""
        let headers = ["Authorization": "Bearer \(accessToken)"]
        let request = NSURLRequest(url: URL(string: url)!)
        
        stompClient.openSocketWithURLRequest(request: request, delegate: self, connectionHeaders: headers)
    }
    
    func disconnect() {
        stompClient.disconnect()
    }
    
    func sendMessage(roomId: String, content: String) {
        let destination = "/pub/chat.message.1"
        let accessToken = KeychainHelper.loadAccessToken() ?? ""
        let headers = ["Authorization": "Bearer \(accessToken)"]
        let message = ["roomId": roomId, "content": content]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: message, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            stompClient.sendMessage(message: jsonString, toDestination: destination, withHeaders: headers, withReceipt: nil)
            Log.debug("sendMessage: \(roomId), \(content)")
        } catch {
            Log.error("Error sending message: \(error)")
        }
    }
}

// MARK: StompClientLibDelegate

extension DefaultChatStompUseCase: StompClientLibDelegate {
    func stompClientDidConnect(client: StompClientLib!) {
        Log.debug("Socket connected")
        isConnected = true
        let accessToken = KeychainHelper.loadAccessToken() ?? ""
        let headers = ["Authorization": "Bearer \(accessToken)"]
        client.sendMessage(message: "", toDestination: "/chat", withHeaders: headers, withReceipt: nil)
        
        subscribeToChat()
        subscribeToErrors()
    }
    
    private func subscribeToChat() {
        let chatRoomReceiptId = "chat-room-receipt-\(Date().timeIntervalSince1970)"
        stompClient.subscribeWithHeader(destination: "/sub/chat.room.1", withHeader: ["receipt": chatRoomReceiptId])
    }
    
    private func subscribeToErrors() {
        let errorReceiptId = "error-receipt-\(Date().timeIntervalSince1970)"
        stompClient.subscribeWithHeader(destination: "/user/queue/errors", withHeader: ["receipt": errorReceiptId])
    }
    
    func stompClientDidDisconnect(client _: StompClientLib!) {
        Log.debug("Socket disconnected")
        isConnected = false
    }
    
    func stompClient(client _: StompClientLib!, didReceiveMessageWithJSONBody _: AnyObject?, akaStringBody _: String?, withHeader _: [String: String]?, withDestination _: String) {
//        if let stringBody = stringBody,
//           let data = stringBody.data(using: .utf8),
//           let chatMessage = try? JSONDecoder().decode(Chat.self, from: data)
//        {
//            messages.append(chatMessage)
//        }
    }
    
    func serverDidSendReceipt(client _: StompClientLib!, withReceiptId receiptId: String) {
        Log.debug("Receipt received: \(receiptId)")
    }
    
    func serverDidSendError(client _: StompClientLib!, withErrorMessage description: String, detailedErrorMessage _: String?) {
        Log.error("Error: \(description)")
    }
    
    func serverDidSendPing() {
        Log.debug("Server ping received")
    }
}
