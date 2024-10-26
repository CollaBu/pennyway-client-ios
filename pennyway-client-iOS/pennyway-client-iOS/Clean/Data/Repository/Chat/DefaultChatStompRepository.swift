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
    private var connectCompletion: ((Result<Void, Error>) -> Void)?
    
    init(stompClient: StompClientLib) {
        self.stompClient = stompClient
    }
    
    /// Stomp 서버에 연결하는 메서드. 먼저 채팅 서버 URL을 가져온 뒤 소켓 연결을 시도함
    func connect(completion: @escaping (Result<Void, Error>) -> Void) {
        getChatServer { [weak self] result in
            switch result {
            case let .success(url):
                self?.chatServerUrl = url
                self?.connectCompletion = completion
                self?.connectToSocket()
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    /// Stomp 소켓 연결을 해제하는 메서드
    func disconnect() {
        stompClient.disconnect()
    }
    
    /// 메시지를 특정 목적지로 보내는 메서드
    func sendMessage(message _: String, destination _: String) {}
    
    /// 특정 목적지로 Stomp 구독을 설정하는 메서드
    func subscribeToDestination(_: String) {}

    /// 에러 처리위해 Stomp 구독을 설정하는 메서드
    private func subscribeToErrors() {
        let errorReceiptId = "error-receipt-\(Date().timeIntervalSince1970)"
        stompClient.subscribeWithHeader(destination: "/user/queue/errors", withHeader: ["receipt": errorReceiptId])
    }
    
    /// 실제로 소켓 연결을 수행하는 메서드
    private func connectToSocket() {
        guard let url = chatServerUrl else {
            connectCompletion?(.failure(NSError(domain: "ChatStompRepository", code: 0, userInfo: [NSLocalizedDescriptionKey: "Chat server URL is not set"])))
            connectCompletion = nil
            return
        }
        
        let accessToken = KeychainHelper.loadAccessToken() ?? ""
        let deviceName = DeviceInfoManager.getDeviceModelName()
        let deviceId = DeviceInfoManager.getDeviceId()
        let headers = ["Authorization": "Bearer \(accessToken)", "device-id": "\(deviceId)", "device-name": "\(deviceName)"]
        
        let request = NSURLRequest(url: URL(string: url)!)
        
        stompClient.openSocketWithURLRequest(request: request, delegate: self, connectionHeaders: headers)
    }
    
    /// 채팅 서버 URL을 가져오는 메서드
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
        subscribeToErrors()//소켓 연결 성공할 때마다 error 구독
        connectCompletion?(.success(()))
        connectCompletion = nil
    }
    
    func stompClientDidDisconnect(client _: StompClientLib!) {
        Log.debug("Socket disconnected")
        connectCompletion?(.failure(NSError(domain: "ChatStompRepository", code: 2, userInfo: [NSLocalizedDescriptionKey: "Socket disconnected"])))
        connectCompletion = nil
    }
    
    func stompClient(client _: StompClientLib!, didReceiveMessageWithJSONBody _: AnyObject?, akaStringBody _: String?, withHeader _: [String: String]?, withDestination _: String) {}
    
    func serverDidSendReceipt(client _: StompClientLib!, withReceiptId receiptId: String) {
        Log.debug("Receipt received: \(receiptId)")
    }
    
    func serverDidSendError(client _: StompClientLib!, withErrorMessage description: String, detailedErrorMessage _: String?) {
        Log.error("Error: \(description)")
        connectCompletion?(.failure(NSError(domain: "ChatStompRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: description])))
        connectCompletion = nil
    }
    
    func serverDidSendPing() {
        Log.debug("Server ping received")
    }
}
