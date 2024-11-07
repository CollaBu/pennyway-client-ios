//
//  ChatRoomViewModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Foundation

// MARK: - ChatRoomViewModelInput

protocol ChatRoomViewModelInput {
    func getChatRoomDetail(chatRoomId: Int64)
}

// MARK: - ChatRoomViewModelOutput

protocol ChatRoomViewModelOutput {
    var roomDetailData: Observable<ChatRoomDetailItemModel?> { get set }
    var messageData: Observable<[MessageItemModel]> { get set }
    var chatUserData: Observable<[ChatUserInfoItemModel]> { get set }
}

// MARK: - ChatRoomViewModel

protocol ChatRoomViewModel: ChatRoomViewModelInput, ChatRoomViewModelOutput {}

// MARK: - DefaultChatRoomViewModel

class DefaultChatRoomViewModel: ChatRoomViewModel {
    var roomDetailData: Observable<ChatRoomDetailItemModel?> = Observable(nil)
    var messageData: Observable<[MessageItemModel]> = Observable([])
    var chatUserData: Observable<[ChatUserInfoItemModel]> = Observable([])

    private let chatRoomUseCase: ChatRoomUseCase
    private let sendChatUseCase: SendChatUseCase

    init(chatRoomUseCase: ChatRoomUseCase, sendChatUseCase: SendChatUseCase) {
        self.chatRoomUseCase = chatRoomUseCase
        self.sendChatUseCase = sendChatUseCase
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
                    self?.chatUserData.value = recentParticipants
                }
            case let .failure(error):
                Log.error("채팅방 상세 정보 가져오기 실패: \(error.localizedDescription)")
            }
        }
    }
    func sendMessage(message: String, destination: String, contentType: String){
        sendChatUseCase.sendMessage(message: message, destination: destination, contentType: contentType) {_ in 
            
        }
    }
}
