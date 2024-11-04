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
}

// MARK: - ChatRoomViewModel

protocol ChatRoomViewModel: ChatRoomViewModelInput, ChatRoomViewModelOutput {}

// MARK: - DefaultChatRoomViewModel

class DefaultChatRoomViewModel: ChatRoomViewModel {
    var roomDetailData: Observable<ChatRoomDetailItemModel?> = Observable(nil)

    private let chatRoomUseCase: ChatRoomUseCase

    init(chatRoomUseCase: ChatRoomUseCase) {
        self.chatRoomUseCase = chatRoomUseCase
    }

    func getChatRoomDetail(chatRoomId: Int64) {
        chatRoomUseCase.getChatRoomDetail(chatRoomId: chatRoomId) { [weak self] result in
            switch result {
            case .success(let chatRoomDetail):
                self?.roomDetailData.value = ChatRoomDetailItemModel.from(model: chatRoomDetail)
            case .failure(let error):
                Log.error("채팅방 상세 정보 가져오기 실패: \(error.localizedDescription)")
            }
        }
    }
}
