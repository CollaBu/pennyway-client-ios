//
//  GetChatRoomViewModel.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/9/24.
//

import Foundation
import UIKit

// MARK: - GetChatRoomViewModelInput

protocol GetChatRoomViewModelInput {
    func getChatRoom()
}

// MARK: - GetChatRoomViewModelOutput

protocol GetChatRoomViewModelOutput {
    var roomData: Observable<[ChatRoomItemModel]> { get set }
}

// MARK: - GetChatRoomViewModel

protocol GetChatRoomViewModel: GetChatRoomViewModelInput, GetChatRoomViewModelOutput {}

// MARK: - DefaultGetChatRoomViewModel

class DefaultGetChatRoomViewModel: GetChatRoomViewModel {
    @Published var roomData: Observable<[ChatRoomItemModel]>

    private let getChatRoomUseCase: GetChatRoomUseCase

    init(getChatRoomUseCase: GetChatRoomUseCase) {
        self.getChatRoomUseCase = getChatRoomUseCase

        roomData = Observable([ChatRoomItemModel(id: 0, title: "", description: "", backgroundImageUrl: "", isPrivate: false, isAdmin: false, participantCount: 0)])
    }

    /// 내 채팅방 조회 요청
    func getChatRoom() {
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
                                participantCount: chatRoomDetail.participantCount
                            )
                        }
                        Log.debug("[ChatViewModel]: 내 채팅방 조회 성공")
                    }
                } else {
                    Log.debug("[ChatViewModel]: 내 채팅방 조회 실패")
                }
            }
        }
    }
}
