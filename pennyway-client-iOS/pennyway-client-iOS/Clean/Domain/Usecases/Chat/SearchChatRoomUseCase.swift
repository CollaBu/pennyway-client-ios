//
//  SearchChatRoomUseCase.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/2/24.
//

import Foundation

// MARK: - SearchChatRoomUseCase

/// 채팅방 검색 usecase를 정의하는 프로토콜
protocol SearchChatRoomUseCase {
    func execute(target: String, page: Int, completion: @escaping (Bool, [SearchChatRoomItemModel]?) -> Void)
}

// MARK: - DefaultSearchChatRoomUseCase

class DefaultSearchChatRoomUseCase: SearchChatRoomUseCase {
    private let searchChatRoomRepository: SearchChatRoomRepository

    init(searchChatRoomRepository: SearchChatRoomRepository) {
        self.searchChatRoomRepository = searchChatRoomRepository
    }

    func execute(target: String, page: Int, completion: @escaping (Bool, [SearchChatRoomItemModel]?) -> Void) {
        let searchModel = SearchChatRoom(target: target, page: page)

        searchChatRoomRepository.execute(model: searchModel) { result in
            switch result {
            case let .success(chatRooms):
                // ChatRoom 데이터를 SearchChatRoomItemModel로 변환
                let chatRoomItemModels = chatRooms.map { chatRoom in
                    return SearchChatRoomItemModel(
                        id: Int(chatRoom.id),
                        title: chatRoom.title,
                        description: chatRoom.description, 
                        isPrivate: chatRoom.isPrivate,
                        backgroundImageUrl: chatRoom.background_image_url,
                        participantCount: chatRoom.participantCount)
                }
                Log.debug("[SearchChatRoomUseCase] 채팅 검색 성공")
                completion(true, chatRoomItemModels)

            case let .failure(error):
                Log.debug("[SearchChatRoomUseCase] 채팅 검색 실패: \(error)")
                completion(false, nil) // 실패 시 false와 nil 전달
            }
        }
    }
}
