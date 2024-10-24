//
//  GetChatRoomUseCase.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/24/24.
//

import Foundation

// MARK: - GetChatRoomUseCase

protocol GetChatRoomUseCase {
    func getChatRoom(completion: @escaping (Bool) -> Void)
}

// MARK: - DefaultGetChatRoomUseCase

class DefaultGetChatRoomUseCase: GetChatRoomUseCase {
    private let repository: GetChatRoomRepository

    init(repository: GetChatRoomRepository) {
        self.repository = repository
    }

    func getChatRoom(completion: @escaping (Bool) -> Void) {
        repository.getChatRoom { result in
            switch result {
            case let .success(response):
                Log.debug("[GetChatRoomUseCase]-채팅방 조회 성공: \(response)")
                completion(true)
            case let .failure(error):
                Log.debug("[GetChatRoomUseCase]-채팅방 조회 실패: \(error)")
                completion(false)
            }
        }
    }
}
