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

// class DefaultChatStompService {
//    static let shared = DefaultChatStompService()
//
//    private let repository: ChatStompRepository
//    private let stompClient: StompClientLib
//    private var socketClient: StompClientLib?
//    private var chatServerUrl: String?
//    
//    init(repository: ChatStompRepository, stompClient: StompClientLib) {
//        self.repository = repository
//        self.stompClient = stompClient
//    }
//    
//    func connect() {
//        repository.getChatServer { result in
//            switch result {
//            case let .success(url):
//                self.chatServerUrl = String(describing: url)
//                Log.debug("[DefaultChatStompUseCase] getChatServer \(String(describing: url))")
//                
//                if let chatServerUrl = self.chatServerUrl {
//                    Log.debug("[DefaultChatStompUseCase] getChatServer \(chatServerUrl)")
//                }
//                
//                self.connectToSocket()
//                
//            case let .failure(error):
//                Log.error("Failed to get chat server URL: \(error)")
//            }
//        }
//    }
//    
//    private func connectToSocket() {
//        guard let url = chatServerUrl else {
//            return
//        }
//        
//        Log.debug("[DefaultChatStompUseCase] connectToSocket()")
//        
//        let accessToken = KeychainHelper.loadAccessToken() ?? ""
//        let headers = ["Authorization": "Bearer \(accessToken)"]
//        let request = NSURLRequest(url: URL(string: url)!)
//        
//        stompClient.openSocketWithURLRequest(request: request, delegate: self, connectionHeaders: headers)
//    }
//    
//    func disconnect() {
//        stompClient.disconnect()
//    }
// }
//
//// MARK: StompClientLibDelegate
//
// extension DefaultChatStompService: StompClientLibDelegate {
//    func stompClientDidConnect(client: StompClientLib!) {
//        Log.debug("Socket connected")
//        let accessToken = KeychainHelper.loadAccessToken() ?? ""
//        let headers = ["Authorization": "Bearer \(accessToken)"]
//        client.sendMessage(message: "", toDestination: "/chat", withHeaders: headers, withReceipt: nil)
//        
//        subscribeToChat()
//        subscribeToErrors()
//    }
//    
//    private func subscribeToChat() {
//        let chatRoomReceiptId = "chat-room-receipt-\(Date().timeIntervalSince1970)"
//        stompClient.subscribeWithHeader(destination: "/sub/chat.room.1", withHeader: ["receipt": chatRoomReceiptId])
//    }
//    
//    private func subscribeToErrors() {
//        let errorReceiptId = "error-receipt-\(Date().timeIntervalSince1970)"
//        stompClient.subscribeWithHeader(destination: "/user/queue/errors", withHeader: ["receipt": errorReceiptId])
//    }
//    
//    func stompClientDidDisconnect(client _: StompClientLib!) {
//        Log.debug("Socket disconnected")
//    }
//    
//    func stompClient(client _: StompClientLib!, didReceiveMessageWithJSONBody _: AnyObject?, akaStringBody _: String?, withHeader _: [String: String]?, withDestination _: String) {}
//    
//    func serverDidSendReceipt(client _: StompClientLib!, withReceiptId receiptId: String) {
//        Log.debug("Receipt received: \(receiptId)")
//    }
//    
//    func serverDidSendError(client _: StompClientLib!, withErrorMessage description: String, detailedErrorMessage _: String?) {
//        Log.error("Error: \(description)")
//    }
//    
//    func serverDidSendPing() {
//        Log.debug("Server ping received")
//    }
// }
