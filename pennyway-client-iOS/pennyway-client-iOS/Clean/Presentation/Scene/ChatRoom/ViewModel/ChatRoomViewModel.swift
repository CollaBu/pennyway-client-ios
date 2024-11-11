//
//  ChatRoomViewModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Combine
import Foundation

// MARK: - ChatRoomViewModelInput

protocol ChatRoomViewModelInput {
    func reset()
    func getChatRoomDetail(chatRoomId: Int64)
    func getPreviousChat(chatRoomId: Int64, lastMessageId: Int64)
    func sendMessage(message: String, destination: Int64, contentType: String)
}

// MARK: - ChatRoomViewModelOutput

protocol ChatRoomViewModelOutput {
    var roomData: Observable<ChatRoomItemModel?> { get set }
    var roomDetailData: Observable<ChatRoomDetailItemModel?> { get set }
    var messageData: Observable<[MessageItemModel]> { get set }
    var chatUserData: Observable<[ChatMemberItemModel]> { get set }
}

// MARK: - ChatRoomViewModel

protocol ChatRoomViewModel: ChatRoomViewModelInput, ChatRoomViewModelOutput {}

// MARK: - DefaultChatRoomViewModel

class DefaultChatRoomViewModel: ChatRoomViewModel {
    var roomData: Observable<ChatRoomItemModel?> = Observable(nil)
    var roomDetailData: Observable<ChatRoomDetailItemModel?> = Observable(nil)
    var messageData: Observable<[MessageItemModel]> = Observable([]) // 최근 메시지 목록
    var chatUserData: Observable<[ChatMemberItemModel]> = Observable([]) // 최근 사용자 + 자신

    private var previousMessageData: Observable<PreviousMessage?> = Observable(nil)

    private let chatRoomUseCase: ChatRoomUseCase
    private let sendChatUseCase: SendChatUseCase

    private var cancellables = Set<AnyCancellable>()

    init(chatRoomUseCase: ChatRoomUseCase, sendChatUseCase: SendChatUseCase) {
        self.chatRoomUseCase = chatRoomUseCase
        self.sendChatUseCase = sendChatUseCase

        // NotificationCenter에서 메시지 알림 구독
        NotificationCenter.default.publisher(for: .didReceiveMessage)
            .sink { [weak self] notification in

                if let message = notification.object as? MessageItemModel {
                    self?.messageData.value.insert(message, at: 0)
                }
            }
            .store(in: &cancellables)
    }

    func reset() {
        roomData.value = nil
        roomDetailData.value = nil
        messageData.value = []
        chatUserData.value = []
        previousMessageData.value = nil
    }

    /// 채팅방 상세 정보 조회
    func getChatRoomDetail(chatRoomId: Int64) {
        chatRoomUseCase.getChatRoomDetail(chatRoomId: chatRoomId) { [weak self] result in
            switch result {
            case let .success(chatRoomDetail):
                self?.roomDetailData.value = ChatRoomDetailItemModel.from(model: chatRoomDetail)
                if let recentMessages = self?.roomDetailData.value?.recentMessages {
                    self?.messageData.value = recentMessages
                }
                if let recentParticipants = self?.roomDetailData.value?.recentParticipants {
                    if let myInfo = self?.roomDetailData.value?.myInfo {
                        self?.chatUserData.value = [myInfo] + recentParticipants
                    }
                }

            case let .failure(error):
                Log.error("[DefaultChatRoomViewModel] 채팅방 상세 정보 가져오기 실패: \(error.localizedDescription)")
            }
        }
    }

    func getPreviousChat(chatRoomId: Int64, lastMessageId: Int64) {
        // previousMessageData가 nil일 경우 또는 hasNext가 true인 경우에만 채팅을 불러옴
        if previousMessageData.value == nil || (previousMessageData.value?.hasNext == true) {
            chatRoomUseCase.getPreviousChat(chatRoomId: chatRoomId, lastMessageId: lastMessageId) { [weak self] result in
                switch result {
                case let .success(previousMessage):
                    // PreviousMessage를 MessageItemModel로 변환
                    let messages = PreviousMessage.to(model: previousMessage)

                    // 이전 메시지 데이터 업데이트
                    self?.previousMessageData.value = previousMessage
                    self?.messageData.value.append(contentsOf: messages)
                    Log.debug("[DefaultChatRoomViewModel] 이전 채팅 조회 성공: \(previousMessage)")

                case let .failure(error):
                    Log.error("[DefaultChatRoomViewModel] 이전 채팅 조회 실패: \(error.localizedDescription)")
                }
            }
        } else {
            // 이전 메시지가 더 이상 없으면 호출하지 않음
            Log.debug("[DefaultChatRoomViewModel] 이전 메시지가 더 이상 없음.")
        }
    }

    /// 채팅 메시지 전송
    /// - Parameters:
    ///   - message: 전송할 메시지 내용.
    ///   - destination: 채팅방  ID.
    ///   - contentType: 메시지의 콘텐츠 유형.
    func sendMessage(message: String, destination: Int64, contentType: String) {
        sendChatUseCase.sendMessage(message: message, destination: destination, contentType: contentType) { result in
            switch result {
            case .success:
                Log.debug("[DefaultChatRoomViewModel] 채팅 메시지 전송 성공")
            case let .failure(error):
                Log.error("[DefaultChatRoomViewModel] 채팅 메시지 전송 실패: \(error.localizedDescription)")
            }
        }
    }
}
