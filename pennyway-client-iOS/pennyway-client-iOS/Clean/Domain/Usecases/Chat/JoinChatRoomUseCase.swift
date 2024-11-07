//
//  JoinChatRoomUseCase.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/6/24.
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

    init(repository: JoinChatRoomRepository) {
        self.repository = repository
    }

    func execute(chatRoomId: Int64, password: String, completion: @escaping (Result<ChatRoom, any Error>) -> Void) {
        repository.execute(chatRoomId: chatRoomId, password: password) { result in
            completion(result)
        }
    }
}
