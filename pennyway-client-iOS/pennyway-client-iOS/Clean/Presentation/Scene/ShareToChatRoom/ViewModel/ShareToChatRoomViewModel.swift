//
//  ShareToChatRoomViewModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 2/4/25.
//

import Foundation

// MARK: - ShareToChatRoomViewModelInput

protocol ShareToChatRoomViewModelInput {
    func getChatRoom(completion: @escaping (Bool) -> Void)
}

// MARK: - ShareToChatRoomViewModelOutput

protocol ShareToChatRoomViewModelOutput {
    var roomData: Observable<[ChatRoomItemModel]> { get set }
}

// MARK: - ShareToChatRoomViewModel

protocol ShareToChatRoomViewModel: ShareToChatRoomViewModelInput, ShareToChatRoomViewModelOutput {}

// MARK: - DefaultShareToChatRoomViewModel

class DefaultShareToChatRoomViewModel: ShareToChatRoomViewModel, ObservableObject {
    @Published var roomData: Observable<[ChatRoomItemModel]>

    private let getChatRoomUseCase: GetChatRoomUseCase
    private let shareToChatRoomUseCase: ShareToChatRoomUseCase

    init(getChatRoomUseCase: GetChatRoomUseCase, shareToChatRoomUseCase: ShareToChatRoomUseCase) {
        self.getChatRoomUseCase = getChatRoomUseCase
        self.shareToChatRoomUseCase = shareToChatRoomUseCase

        roomData = Observable([])
    }

    /// 내 채팅방 조회 요청
    func getChatRoom(completion: @escaping (Bool) -> Void) {
        getChatRoomUseCase.getChatRoom { [weak self] success, chatRooms in
            DispatchQueue.main.async {
                if success {
                    if let chatRooms = chatRooms {
                        self?.roomData.value = chatRooms.map { chatRoomDetail in
                            return ChatRoomItemModel(
                                id: chatRoomDetail.id,
                                title: chatRoomDetail.title,
                                description: chatRoomDetail.description,
                                backgroundImageUrl: chatRoomDetail.backgroundImageUrl,
                                isPrivate: chatRoomDetail.isPrivate,
                                isAdmin: chatRoomDetail.isAdmin,
                                participantCount: chatRoomDetail.participantCount,
                                lastMassage: chatRoomDetail.lastMassage,
                                unreadMessageCount: chatRoomDetail.unreadMessageCount
                            )
                        }
                        Log.debug("[ShareToChatRoomViewModel]: 내 채팅방 조회 성공")
                        completion(true)
                    }
                } else {
                    Log.debug("[ShareToChatRoomViewModel]: 내 채팅방 조회 실패")
                    completion(false)
                }
            }
        }
    }
}
