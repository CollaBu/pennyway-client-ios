//
//  DefaultChatStompRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/15/24.
//

import Foundation
import StompClientLib

// MARK: - DefaultChatStompRepository

class DefaultChatStompRepository: ChatStompRepository {
    private let stompClient: StompClientLib
    private var messageDatas: [String: [String: String]] = [:]

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
        // 소켓 연결 해제
        stompClient.disconnect()
        Log.info("[Disconnect] 모든 구독이 해제되고 소켓 연결 해제")
    }

    /// 메시지를 특정 목적지로 보내는 메서드
    func sendMessage(message: String, chatRoomId: Int64, contentType: String, retry _: Bool? = false, uuid: String? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        let destination = "/pub/chat.message.\(chatRoomId)"
        let messageUuid = uuid ?? GenerateUuid.generateSequentialUuid().uuidString
        let headers = createSendMessageIdHeaders(uuid: messageUuid)
        let messageBody: [String: String] = [
            "content": message,
            "contentType": contentType
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: messageBody, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                stompClient.sendMessage(message: jsonString, toDestination: destination, withHeaders: headers, withReceipt: nil)
                messageDatas[messageUuid] = ["message": message, "chatRoomId": String(chatRoomId), "contentType": contentType]
                Log.info("📤 [Send Message] total - \(String(describing: messageDatas))")
                Log.info("📤 [Send Message] - \(String(describing: messageDatas[messageUuid]))")
                completion(.success(()))
            }
        } catch {
            Log.error("Failed to serialize message body: \(error)")
            completion(.failure(error))
        }
    }

    /// 마지막으로 읽은 메시지를 특정 목적지로 보내는 메서드
    func sendLastMessage(chatRoomId: Int64, lastReadMessageId: Int64, completion _: @escaping (Result<Void, Error>) -> Void) {
        let destination = "/pub/chat.message.\(chatRoomId).read.\(lastReadMessageId) "
        let headers = createSendHeaders()

        stompClient.sendMessage(message: "", toDestination: destination, withHeaders: headers, withReceipt: nil)
        Log.info("📤 [Send Last Message])")
    }

    /// 채팅방 ID 에 대한 구독을 설정하는 메서드
    func subscribeToChatRoom(chatRoomId: Int64) {
        let chatRoomReceiptId = "chat-room-receipt-\(UUID().uuidString)"
        let destination = "/sub/chat.room.\(chatRoomId)"
        stompClient.subscribeWithHeader(destination: destination, withHeader: ["receipt": chatRoomReceiptId])
    }

    /// 뷰 상태를 전달하는 메서드
    func sendViewState(status: String, chatRoomId: Int64?) {
        let destination = "/pub/status.me"
        let headers = createSendHeaders()

        var messageBody: [String: Any] = [
            "status": status
        ]

        // chatRoomId가 nil값이 아닌 경우 body에 포함
        if let chatRoomId = chatRoomId {
            messageBody["chatRoomId"] = chatRoomId
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: messageBody, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                stompClient.sendMessage(message: jsonString, toDestination: destination, withHeaders: headers, withReceipt: nil)
                Log.info("📤 [Send User State] \(jsonString)")
            }
        } catch {
            Log.error("Failed to serialize message body: \(error)")
        }
    }
}

// MARK: Private Methods

extension DefaultChatStompRepository {
    /// 에러 처리위해 Stomp 구독을 설정하는 메서드
    private func subscribeToErrors() {
        let destination = "/user/queue/errors"
        let errorReceiptId = "error-receipt-\(UUID().uuidString)"
        stompClient.subscribeWithHeader(destination: destination, withHeader: ["receipt": errorReceiptId])
    }

    /// 메시지 전송 성공 처리에 대한 구독을 설정하는 메서드
    private func subscribeToSuccess() {
        let errorReceiptId = "success-receipt-\(UUID().uuidString)"
        stompClient.subscribeWithHeader(destination: "/user/queue/success", withHeader: ["receipt": errorReceiptId])
    }

    /// 채팅방 ID 리스트에 대한 구독을 설정하는 메서드
    private func subscribeToChatRooms(_ chatRoomIds: [Int64]) {
        for chatRoomId in chatRoomIds {
            let chatRoomReceiptId = "chat-room-receipt-\(UUID().uuidString)"
            let destination = "/sub/chat.room.\(chatRoomId)"
            stompClient.subscribeWithHeader(destination: destination, withHeader: ["receipt": chatRoomReceiptId])
        }
    }

    /// 실제로 소켓 연결을 수행하는 메서드
    private func connectToSocket(url: String) {
        Log.debug("[connectToSocket] - 소켓 연결 수행")
        let headers = createConnectionHeaders()

        let request = NSURLRequest(url: URL(string: url)!)

        stompClient.openSocketWithURLRequest(request: request, delegate: self, connectionHeaders: headers)
    }

    private func createSendMessageIdHeaders(uuid: String) -> [String: String] {
        let headers = ["Authorization": "Bearer \(KeychainHelper.loadAccessToken() ?? "")",
                       "content-type": "application/json",
                       "x-message-id": uuid
        ]
        return headers
    }

    private func createSendHeaders() -> [String: String] {
        let headers = ["Authorization": "Bearer \(KeychainHelper.loadAccessToken() ?? "")",
                       "content-type": "application/json"]
        return headers
    }

    private func createConnectionHeaders() -> [String: String] {
        let accessToken = KeychainHelper.loadAccessToken() ?? ""
        let deviceName = DeviceInfoManager.getDeviceModelName()
        let deviceId = DeviceInfoManager.getDeviceId()
        return [
            "Authorization": "Bearer \(accessToken)",
            "device-id": "\(deviceId)",
            "device-name": "\(deviceName)",
            "heart-beat": "25000,25000"
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

    /// `/user/queue/success`에서 받은 메시지 처리
    private func handleRemovedMessage(header: [String: String]?) {
        if let id = header?["x-message-id"] {
            messageDatas.removeValue(forKey: id)
            Log.info("📤 [Send Message] Removed ID \(id). Remaining messages: \(messageDatas)")
        }
    }

    /// refresh token을 서버에 전송하는  메서드
    private func sendRefreshToken() {
        let destination = "/pub/auth.refresh"
        let receiptId = "refresh-receipt-\(UUID().uuidString)"
        let headers = ["Authorization": "Bearer \(KeychainHelper.loadAccessToken() ?? "")",
                       "content-type": "application/json",
                       "receipt": receiptId]

        stompClient.sendMessage(message: "", toDestination: destination, withHeaders: headers, withReceipt: nil)

        Log.info("📤 [Send RefreshToken])")
    }

    /// 보내지지 않은 메시지 보내는 메서드
    private func retryUnsentMessages() {
        let sortedMessages = messageDatas.keys.sorted().map { uuid -> (String, [String: String]) in
            (uuid, self.messageDatas[uuid]!)
        }

        for (uuid, data) in sortedMessages {
            guard let message = data["message"],
                  let chatRoomIdString = data["chatRoomId"],
                  let chatRoomId = Int64(chatRoomIdString),
                  let contentType = data["contentType"]
            else {
                Log.error("📤 [Retry Messages] Invalid message data: \(data)")
                continue
            }

            sendMessage(message: message, chatRoomId: chatRoomId, contentType: contentType, retry: true, uuid: uuid) { [weak self] result in
                switch result {
                case .success:
                    Log.info("📤 [Retry Messages] Successfully sent message with UUID: \(uuid)")
                case let .failure(error):
                    Log.error("📤 [Retry Messages] Failed to resend message with UUID: \(uuid), Error: \(error)")
                }
            }
        }
    }
}

// MARK: StompClientLibDelegate

extension DefaultChatStompRepository: StompClientLibDelegate {
    func stompClientDidConnect(client _: StompClientLib!) {
        Log.info("Socket connected")
        subscribeToErrors()
        subscribeToSuccess()
        getJoinedChatRooms()
    }

    func stompClientDidDisconnect(client _: StompClientLib!) {
        Log.fault("Socket disconnected")

        connect { result in
            switch result {
            case .success:
                Log.debug("[DefaultChatStompRepository] 재연결 시도 성공")
            case let .failure(error):
                Log.error("재연결 시도 실패: \(error)")
            }
        }
    }

    func stompClient(client _: StompClientLib!, didReceiveMessageWithJSONBody body: AnyObject?, akaStringBody akaStringBody: String?, withHeader header: [String: String]?, withDestination _: String) {
        Log.info("Did receive Message: body - \(body), \(akaStringBody), \n header - \(header)")

        // `destination` 확인
        if let destination = header?["destination"], destination == "/user/queue/success" {
            handleRemovedMessage(header: header)
            return
        }

        if let body = body as? [String: Any], let code = body["code"] as? String, code == "4011" {
            Log.info("📤 [Retry Messages] Error code \(code) detected. Retrying unsent messages.")
            TokenRefreshHandler.shared.refreshSync { result, _ in
                switch result {
                case .success:
                    Log.debug("Token refreshed, retrying request sucess")
                    self.sendRefreshToken()

                case .failure:
                    Log.debug("Token refreshed, retrying request fail")
                }
            }
        }

        if let body = body as? [String: Any],
           let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8)
        {
            let messageDto = GetMessage.parseGetMessage(from: jsonString)

            switch messageDto {
            case let .success(messageDto):
                // NotificationCenter를 통해 viewModel에 메시지를 전달
                let message = GetMessage.toItemModel(dto: messageDto)
                NotificationCenter.default.post(name: .didReceiveMessage, object: message)
                Log.debug("[NotificationCenter] chat 전달: \(message)")
            case let .failure(error):
                Log.error("[NotificationCenter] chat Failed to parse message: \(error)")
            }
        }
    }

    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        Log.info("Receipt received: \(receiptId) \(String(describing: client))")

        // receiptId가 "refresh-receipt-"로 시작하는 경우 처리
        if receiptId.hasPrefix("refresh-receipt-") {
            retryUnsentMessages()
        }
    }

    func serverDidSendError(client _: StompClientLib!, withErrorMessage description: String, detailedErrorMessage detailedErrorMessage: String?) {
        Log.error("Error: \(description) \n detail: \(detailedErrorMessage)")
    }

    func serverDidSendPing() {
        Log.info("Server ping received")
    }
}
