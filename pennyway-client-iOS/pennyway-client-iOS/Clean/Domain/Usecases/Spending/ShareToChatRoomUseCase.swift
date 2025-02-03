//
//  ShareToChatRoomUseCase.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 2/4/25.
//

import Foundation

// MARK: - ShareToChatRoomUseCase

protocol ShareToChatRoomUseCase {
    func shareToChatRoom(date: Date, chatRoomIds: [Int64], completion: @escaping (Bool) -> Void)
}

// MARK: - DefaultShareToChatRoomUseCase

class DefaultShareToChatRoomUseCase: ShareToChatRoomUseCase {
    
    private let repository: ShareToChatRoomRepository

    init(repository: ShareToChatRoomRepository) {
        self.repository = repository
    }

    func shareToChatRoom(date: Date, chatRoomIds: [Int64], completion: @escaping (Bool) -> Void) {
        repository.shareToChatRoom(date: date, chatRoomIds: chatRoomIds, completion: completion)
    }
}
