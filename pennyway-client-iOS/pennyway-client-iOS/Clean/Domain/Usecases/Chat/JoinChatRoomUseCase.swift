//
//  JoinChatRoomUseCase.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀, 최희진 on 11/6/24.
//

import Foundation

// MARK: - JoinChatRoomUseCase

/// 채팅방 가입 usecase를 정의하는 프로토콜
protocol JoinChatRoomUseCase {
    func execute(chatRoomId: Int64, password: String, completion: @escaping (Result<ChatRoom, any Error>) -> Void)
}

// MARK: - DefaultJoinChatRoomUseCase

class DefaultJoinChatRoomUseCase: JoinChatRoomUseCase {
    private let repository: JoinChatRoomRepository
    private let chatStompService = DefaultChatStompService.shared

    init(repository: JoinChatRoomRepository) {
        self.repository = repository
    }

    func execute(chatRoomId: Int64, password: String, completion: @escaping (Result<ChatRoom, any Error>) -> Void) {
        repository.execute(chatRoomId: chatRoomId, password: password) { result in
            switch result {
            case let .success(chatRoom):
                Log.debug("[DefaultJoinChatRoomUseCase]: 채팅방 가입 성공")
                self.chatStompService.subscribeToChatRoom(chatRoomId: chatRoom.id)
                completion(.success(chatRoom))

            case let .failure(error):
                Log.fault("[DefaultJoinChatRoomUseCase]: 채팅방 가입 실패, 오류: \(error)")
                completion(.failure(error))
            }
        }
    }
}
