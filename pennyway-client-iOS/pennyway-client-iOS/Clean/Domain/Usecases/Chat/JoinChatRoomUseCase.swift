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
    func execute(chatRoomId: Int64, password: String, completion: @escaping (Bool) -> Void)
}

// MARK: - DefaultJoinChatRoomUseCase

class DefaultJoinChatRoomUseCase: JoinChatRoomUseCase {
    private let repository: JoinChatRoomRepository

    init(repository: JoinChatRoomRepository) {
        self.repository = repository
    }

    func execute(chatRoomId: Int64, password: String, completion: @escaping (Bool) -> Void) {
        repository.joinChatRoom(chatRoomId: chatRoomId, password: password) { result in
            switch result {
            case .success:
                Log.debug("[JoinChatRoomUseCase] 채팅방 가입 성공")
                completion(true)
            case .failure:
                Log.debug("[JoinChatRoomUseCase] 채팅방 가입 실패")
                completion(false)
            }
        }
    }
}
