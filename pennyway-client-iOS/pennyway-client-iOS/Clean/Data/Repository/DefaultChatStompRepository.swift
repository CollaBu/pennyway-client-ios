//
//  DefaultChatStompRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/15/24.
//

import Foundation
import StompClientLib

// MARK: - DefaultChatStompRepository

class DefaultChatStompRepository: NSObject, ChatStompRepository {
    private var stompClient: StompClientLib
    private var chatServerUrl: String?
    
    init(stompClient: StompClientLib) {
        self.stompClient = stompClient
    }
    
    func connect(completion: @escaping (Result<Void, Error>) -> Void) {
        getChatServer { [weak self] result in
            switch result {
            case let .success(url):
                self?.chatServerUrl = url
                self?.connectToSocket(completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func disconnect() {
        stompClient.disconnect()
    }
    
    func sendMessage(message: String, destination: String) {
        let accessToken = KeychainHelper.loadAccessToken() ?? ""
        let headers = ["Authorization": "Bearer \(accessToken)"]
        stompClient.sendMessage(message: message, toDestination: destination, withHeaders: headers, withReceipt: nil)
    }
    
    func subscribeToDestination(_ destination: String) {
        let receiptId = "receipt-\(destination)-\(Date().timeIntervalSince1970)"
        stompClient.subscribeWithHeader(destination: destination, withHeader: ["receipt": receiptId])
    }
    
    private func connectToSocket(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = chatServerUrl else {
            completion(.failure(NSError(domain: "ChatStompRepository", code: 0, userInfo: [NSLocalizedDescriptionKey: "Chat server URL is not set"])))
            return
        }
        
        let accessToken = KeychainHelper.loadAccessToken() ?? ""
        let headers = ["Authorization": "Bearer \(accessToken)"]
        let request = NSURLRequest(url: URL(string: url)!)
        
        stompClient.openSocketWithURLRequest(request: request, delegate: self, connectionHeaders: headers)
        completion(.success(()))
    }
    
    private func getChatServer(completion: @escaping (Result<String, Error>) -> Void) {
        ChatAlamofire.shared.getChatServer { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetChatServerResponseDto.self, from: responseData)
                        Log.debug("[DefaultChatServerRepository] chat 서버 받기 성공: \(response)")
                        completion(.success(response.data.chatServerUrl))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: StompClientLibDelegate

extension DefaultChatStompRepository: StompClientLibDelegate {
    func stompClientDidConnect(client _: StompClientLib!) {
        Log.debug("Socket connected")
    }
    
    func stompClientDidDisconnect(client _: StompClientLib!) {
        Log.debug("Socket disconnected")
    }
    
    func stompClient(client _: StompClientLib!, didReceiveMessageWithJSONBody _: AnyObject?, akaStringBody _: String?, withHeader _: [String: String]?, withDestination _: String) {}
    
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
