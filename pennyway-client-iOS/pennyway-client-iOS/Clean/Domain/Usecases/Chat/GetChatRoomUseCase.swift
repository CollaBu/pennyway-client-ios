//
//  GetChatRoomUseCase.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/24/24.
//

import Foundation
import UIKit

// MARK: - GetChatRoomUseCase

protocol GetChatRoomUseCase {
    func getChatRoom(completion: @escaping (Bool, [ChatRoomItemModel]?) -> Void)
}

// MARK: - DefaultGetChatRoomUseCase

class DefaultGetChatRoomUseCase: GetChatRoomUseCase {
    private let repository: GetChatRoomRepository

    init(repository: GetChatRoomRepository) {
        self.repository = repository
    }

    func getChatRoom(completion: @escaping (Bool, [ChatRoomItemModel]?) -> Void) {
        repository.getChatRoom { result in
            switch result {
            case let .success(chatRooms): // chatRoom은 ChatRoom 타입
                // ChatRoom 데이터를 ChatRoomItemModel로 변환

                let chatRoomItemModels = chatRooms.map { chatRoom in
                    return ChatRoomItemModel(
                        id: chatRoom.id,
                        title: chatRoom.title,
                        description: chatRoom.description,
                        backgroundImageUrl: chatRoom.background_image_url,
                        isPrivate: chatRoom.isPrivate,
                        isAdmin: chatRoom.isAdmin,
                        participantCount: chatRoom.participantCount,
                        lastMassage: MessageItemModel(
                            chatRoomId: chatRoom.lastMassage?.chatRoomId ?? 0,
                            chatId: chatRoom.lastMassage?.chatId ?? 0,
                            content: chatRoom.lastMassage?.content ?? "",
                            contentType: chatRoom.lastMassage?.contentType ?? .text,
                            categoryType: chatRoom.lastMassage?.categoryType ?? .normal,
                            createdAt: chatRoom.lastMassage?.createdAt ?? "",
                            senderId: chatRoom.lastMassage?.senderId ?? 0 
                        ),
                        unreadMessageCount: chatRoom.unreadMessageCount
                    )
                }
                Log.debug("[GetChatRoomUseCase] 내 채팅 조회 성공")
                completion(true, chatRoomItemModels) // 성공 시 데이터와 함께 true 전달

            case let .failure(error):
                Log.debug("[GetChatRoomUseCase] 내 채팅 조회 실패: \(error)")
                completion(false, nil) // 실패 시 false와 nil 전달
            }
        }
    }
}
