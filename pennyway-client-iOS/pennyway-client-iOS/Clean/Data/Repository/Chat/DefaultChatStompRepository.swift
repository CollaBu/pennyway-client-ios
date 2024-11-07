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
    private let stompClient: StompClientLib

    init(stompClient: StompClientLib) {
        self.stompClient = stompClient
    }

    /// Stomp 서버에 연결하는 메서드. 먼저 채팅 서버 URL을 가져온 뒤 소켓 연결을 시도함
    func connect(completion: @escaping (Result<Void, Error>) -> Void) {
        getChatServer { [weak self] result in
            switch result {
            case let .success(url):
                self?.connectToSocket(url: url)
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
    func sendMessage(message: String, destination: Int64, contentType: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let destination = "/pub/chat.message.\(destination)"
        let headers = ["Authorization": "Bearer \(KeychainHelper.loadAccessToken() ?? "")"]
        let messageBody: [String: String] = [
            "content": message,
            "contentType": contentType
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: messageBody, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                stompClient.sendMessage(message: jsonString, toDestination: destination, withHeaders: headers, withReceipt: nil)
                Log.debug("📤 [Send Message]): \(message)")
                completion(.success(()))
            }
        } catch {
            Log.error("Failed to serialize message body: \(error)")
            completion(.failure(error))
        }
    }

    /// 에러 처리위해 Stomp 구독을 설정하는 메서드
    private func subscribeToErrors() {
        let errorReceiptId = "error-receipt-\(UUID().uuidString)"
        stompClient.subscribeWithHeader(destination: "/user/queue/errors", withHeader: ["receipt": errorReceiptId])
    }

    /// 채팅방 ID 리스트에 대한 구독을 설정하는 메서드
    private func subscribeToChatRooms(_ chatRoomIds: [Int]) {
        for chatRoomId in chatRoomIds {
            let chatRoomReceiptId = "chat-room-receipt-\(UUID().uuidString)"
            let destination = "/sub/chat.room.\(chatRoomId)"
            stompClient.subscribeWithHeader(destination: destination, withHeader: ["receipt": chatRoomReceiptId])
        }
    }

    /// 실제로 소켓 연결을 수행하는 메서드
    private func connectToSocket(url: String) {
        let headers = createConnectionHeaders()

        let request = NSURLRequest(url: URL(string: url)!)

        stompClient.openSocketWithURLRequest(request: request, delegate: self, connectionHeaders: headers)
    }

    private func createConnectionHeaders() -> [String: String] {
        let accessToken = KeychainHelper.loadAccessToken() ?? ""
        let deviceName = DeviceInfoManager.getDeviceModelName()
        let deviceId = DeviceInfoManager.getDeviceId()
        return [
            "Authorization": "Bearer \(accessToken)",
            "device-id": "\(deviceId)",
            "device-name": "\(deviceName)"
        ]
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

    /// 가입한 채팅방 리스트 가져오기
    private func getJoinedChatRooms() {
        Log.debug("[DefaultChatServerRepository] 가입한 채팅방 리스트 가져오기")
        ChatAlamofire.shared.getJoinedChatRooms(GetJoinedChatRoomsRequestDto(summary: "true")) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetJoinedChatRoomsResponseDto.self, from: responseData)
                        Log.debug("[DefaultChatServerRepository] 가입한 채팅방 리스트 가져오기 성공: \(response)")
                        // 구독 요청 수행
                        self.subscribeToChatRooms(response.data.chatRoom.chatRoomIds)
                    } catch {
                        Log.error("Failed to decode: \(error)")
                    }
                }
            case let .failure(error):
                if let statusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(statusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
            }
        }
    }
}

// MARK: StompClientLibDelegate

extension DefaultChatStompRepository: StompClientLibDelegate {
    func stompClientDidConnect(client _: StompClientLib!) {
        Log.debug("Socket connected")
        subscribeToErrors()
        getJoinedChatRooms()
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
