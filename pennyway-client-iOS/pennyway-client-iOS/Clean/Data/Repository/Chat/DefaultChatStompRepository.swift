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
    private let stompClient: CustomStompClient
    private let messageQueue: MessageQueue

    init(
        stompClient: CustomStompClient = .shared,
        messageQueue: MessageQueue = .shared
    ) {
        self.stompClient = stompClient
        self.messageQueue = messageQueue
    }

    /// Stomp 서버에 연결하는 메서드
    func connect() {
        stompClient.connect { result in
            switch result {
            case .success:
                Log.debug("[DefaultChatStompRepository] 연결 시도 성공")
            case let .failure(error):
                Log.error("연결 시도 실패: \(error)")
            }
        }
    }

    /// Stomp 소켓 연결을 해제하는 메서드
    func disconnect() {
        // 소켓 연결 해제
        stompClient.disconnect()
    }

    /// 메시지를 특정 목적지로 보내는 메서드
    func sendMessage(message: String, chatRoomId: Int64, contentType: String) {
        let destination = "/pub/chat.message.\(chatRoomId)"
        let messageId = GenerateUuid.generateSequentialUuid().uuidString

        let socketMessage = SocketMessage(
            content: message,
            destination: destination,
            contentType: contentType
        )

        messageQueue.enqueue(message: socketMessage, id: Int(messageId) ?? 0)
    }

    /// 마지막으로 읽은 메시지를 특정 목적지로 보내는 메서드
    func sendLastMessage(chatRoomId: Int64, lastReadMessageId: Int64) {
        stompClient.sendLastMessage(chatRoomId: chatRoomId, lastReadMessageId: lastReadMessageId)
    }

    /// 채팅방 ID 에 대한 구독을 설정하는 메서드
    func subscribeToChatRoom(chatRoomId: Int64) {
        stompClient.subscribeToChatRoom(chatRoomId: chatRoomId)
    }

    /// 뷰 상태를 전달하는 메서드
    func sendViewState(status: String, chatRoomId: Int64?) {
        stompClient.sendViewState(status: status, chatRoomId: chatRoomId)
    }
}
