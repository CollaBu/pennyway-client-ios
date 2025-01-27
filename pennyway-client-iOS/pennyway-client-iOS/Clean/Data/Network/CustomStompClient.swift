//
//  CustomStompClient.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/23/25.
//

import Foundation
import StompClientLib

// MARK: - CustomStompClient

final class CustomStompClient {
    // MARK: - Properties
   
    static let shared = CustomStompClient(stompClient: StompClientLib())
    private let stompClient: StompClientLib
    private let interceptor: RefreshInterceptor
    private let notificationQueue: NotificationQueue
   
    // MARK: - Initialize
   
    private init(
        stompClient: StompClientLib,
        interceptor: RefreshInterceptor = DefaultRefreshInterceptor(socketAuthHandler: SocketAuthHandler.shared),
        notificationQueue: NotificationQueue = .default
    ) {
        self.stompClient = stompClient
        self.interceptor = interceptor
        self.notificationQueue = notificationQueue
    }
}

// MARK: - Public Methods

extension CustomStompClient {
    /// Stomp 서버에 연결하는 메서드. 먼저 채팅 서버 URL을 가져온 뒤 소켓 연결을 시도함
    func connect(completion: @escaping (Result<Void, Error>) -> Void) {
        getChatServer { [weak self] result in
            switch result {
            case let .success(url):
                self?.connectToSocket(url: url)
                completion(.success(()))
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
    
    /// 채팅방 ID 에 대한 구독을 설정하는 메서드
    func subscribeToChatRoom(chatRoomId: Int64) {
        let chatRoomReceiptId = "chat-room-receipt-\(UUID().uuidString)"
        let destination = "/sub/chat.room.\(chatRoomId)"
        stompClient.subscribeWithHeader(destination: destination, withHeader: ["receipt": chatRoomReceiptId])
    }
   
    /// 메시지를 특정 목적지로 보내는 메서드
    func sendMessage(message: String, destination: String, headers: [String: String], contentType: String, receipt: String? = nil) {
        let messageBody: [String: String] = [
            "content": message,
            "contentType": contentType
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: messageBody, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                stompClient.sendMessage(message: jsonString, toDestination: destination, withHeaders: headers, withReceipt: receipt)
                Log.info("📤 [Send Message] - \(message)")
            }
        } catch {
            Log.fault("Failed to serialize message body: \(error)")
        }
    }
    
    /// 마지막으로 읽은 메시지를 특정 목적지로 보내는 메서드
    func sendLastMessage(chatRoomId: Int64, lastReadMessageId: Int64) {
        let destination = "/pub/chat.message.\(chatRoomId).read.\(lastReadMessageId) "
        let headers = createSendHeaders()

        stompClient.sendMessage(message: "", toDestination: destination, withHeaders: headers, withReceipt: nil)
        Log.info("📤 [Send Last Message])")
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
    
    /// refresh token을 서버에 전송하는  메서드
    func sendRefreshToken() {
        let destination = "/pub/auth.refresh"
        let receiptId = "refresh-receipt-\(UUID().uuidString)"
        let headers = ["Authorization": "Bearer \(KeychainHelper.loadAccessToken() ?? "")",
                       "content-type": "application/json",
                       "receipt": receiptId]
        
        stompClient.sendMessage(message: "", toDestination: destination, withHeaders: headers, withReceipt: nil)
        
        Log.info("📤 [Send RefreshToken])")
    }
}

extension CustomStompClient {
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
}

// MARK: StompClientLibDelegate

extension CustomStompClient: StompClientLibDelegate {
    func stompClientDidConnect(client _: StompClientLib!) {
        Log.info("[Socket] Connected")
        
        subscribeToErrors()
        subscribeToSuccess()
        getJoinedChatRooms()
    }
   
    func stompClientDidDisconnect(client _: StompClientLib!) {
        Log.fault("[Socket] Disconnected")
        
        connect { result in
            switch result {
            case .success:
                Log.debug("[DefaultChatStompRepository] 재연결 시도 성공")
            case let .failure(error):
                Log.error("재연결 시도 실패: \(error)")
            }
        }
    }
   
    func stompClient(client _: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody: String?, withHeader: [String: String]?, withDestination _: String) {
        Log.info("Did receive Message: body - \(String(describing: jsonBody)), \(String(describing: akaStringBody)), \n header - \(String(describing: withHeader))")
        
        // destination: `/user/queue/success` 확인
        if let destination = withHeader?["destination"], destination == "/user/queue/success" {
            if let id = withHeader?["x-message-id"] {
                notificationQueue.enqueue(
                    Notification(
                        name: .successSendMessage,
                        object: nil,
                        userInfo: ["messageId": id] // ✅ messageId 전달
                    ),
                    postingStyle: .asap
                )
            }
            return
        }
        
        // error queue에서 401 메시지 수신 시 interceptor 호출
        if let body = jsonBody as? [String: Any],
           let code = body["code"] as? String,
           code == "4011"
        {
            interceptor.handle { result in
                Log.debug("[Socket] Retry result: \(result)")
            }
        }
        
        if let body = jsonBody as? [String: Any],
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
   
    func serverDidSendReceipt(client _: StompClientLib!, withReceiptId receiptId: String) {
        if receiptId.hasPrefix("refresh-receipt-") {
            notificationQueue.enqueue(
                Notification(name: .socketAuthComplete),
                postingStyle: .asap
            )
        }
    }
   
    func serverDidSendError(client _: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        Log.error("[Socket] Error - description: \(description), message: \(message ?? "")")
    }
   
    func serverDidSendPing() {
        Log.debug("[Socket] Ping received")
    }
}
