//
//  GetChatRoomDetailUseCase.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Foundation

// MARK: - ChatRoomUseCase

protocol ChatRoomUseCase {
    func getChatRoomDetail(chatRoomId: Int64, completion: @escaping (Result<ChatRoomDetailInfo, Error>) -> Void)
}

// MARK: - DefaultChatRoomUseCase

class DefaultChatRoomUseCase: ChatRoomUseCase {
    private let repository: ChatRoomRepository

    init(repository: ChatRoomRepository) {
        self.repository = repository
    }

    func getChatRoomDetail(chatRoomId: Int64, completion: @escaping (Result<ChatRoomDetailInfo, Error>) -> Void) {
        repository.getChatRoomDetail(chatRoomId: chatRoomId, completion: completion)
    }
}
