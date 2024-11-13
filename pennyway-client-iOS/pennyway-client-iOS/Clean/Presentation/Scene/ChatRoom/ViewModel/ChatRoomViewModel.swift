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
    func getChatRoomDetail(chatRoomId: Int64)
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

    private let chatRoomUseCase: ChatRoomUseCase
    private let sendChatUseCase: SendChatUseCase
    private let chatHistoryList: ChatHistoryList

    private var cancellables = Set<AnyCancellable>()

    init(chatHistoryList: ChatHistoryList = ChatHistoryBinaryList(), chatRoomUseCase: ChatRoomUseCase, sendChatUseCase: SendChatUseCase) {
        self.chatHistoryList = chatHistoryList
        self.chatRoomUseCase = chatRoomUseCase
        self.sendChatUseCase = sendChatUseCase
        self.chatHistoryList.delegate = self

        // NotificationCenter에서 메시지 알림 구독
        NotificationCenter.default.publisher(for: .didReceiveMessage)
            .sink { [weak self] notification in

                if let message = notification.object as? MessageItemModel {
                    self?.handleNewMessage(message)
                }
            }
            .store(in: &cancellables)
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
                Log.error("[DefaultChatRoomViewModel]  채팅 메시지 전송 실패: \(error.localizedDescription)")
            }
        }
    }

    /// 단일 메시지 삽입
    private func handleNewMessage(_ message: MessageItemModel) {
        chatHistoryList.insert(message)
    }

    /// 여러 메시지 삽입
    private func handleNewMessages(_ messages: [MessageItemModel]) {
        chatHistoryList.insertMessages(messages)
    }
}

// MARK: ChatHistoryDelegate

extension DefaultChatRoomViewModel: ChatHistoryDelegate {
    func chatHistoryDidAdd(_ messages: [MessageItemModel]) {
        messageData.value.insert(contentsOf: messages, at: 0)
    }
}
