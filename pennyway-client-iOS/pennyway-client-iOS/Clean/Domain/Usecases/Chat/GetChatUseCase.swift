//
//  GetChatRoomDetailUseCase.swift
//  pennyway-client-iOS
//
//  Created by 최희진, 아우신얀 on 11/5/24.
//

import Foundation

// MARK: - GetChatUseCase

protocol GetChatUseCase {
    func getChatRoomDetail(chatRoomId: Int64, completion: @escaping (Result<ChatRoomDetailInfo, Error>) -> Void)
    func getPreviousChat(chatRoomId: Int64, lastMessageId: Int64, completion: @escaping (Result<PreviousMessage, Error>) -> Void)
    func getChatMembers(chatRoomId: Int64, ids: [Int64], completion: @escaping (Result<[ChatMember], Error>) -> Void)
    /// 채팅방 나가기 기능을 수행하는 함수
    func deleteChatRoom(chatRoomId: Int64, completion: @escaping (Result<Void, DeleteChatRoomError>) -> Void)
    func deleteChatRoomByAdmin(chatRoomId: Int64, completion: @escaping (Result<Void, DeleteChatRoomError>) -> Void)
}

// MARK: - DefaultGetChatUseCase

class DefaultGetChatUseCase: GetChatUseCase {
    private let repository: GetChatRepository

    init(repository: GetChatRepository) {
        self.repository = repository
    }

    func getChatRoomDetail(chatRoomId: Int64, completion: @escaping (Result<ChatRoomDetailInfo, Error>) -> Void) {
        repository.getChatRoomDetail(chatRoomId: chatRoomId, completion: completion)
    }

    func getPreviousChat(chatRoomId: Int64, lastMessageId: Int64, completion: @escaping (Result<PreviousMessage, Error>) -> Void) {
        repository.getPreviousChat(chatRoomId: chatRoomId, lastMessageId: lastMessageId, completion: completion)
    }

    func getChatMembers(chatRoomId: Int64, ids: [Int64], completion: @escaping (Result<[ChatMember], Error>) -> Void) {
        repository.getChatMembers(chatRoomId: chatRoomId, ids: ids, completion: completion)
    }

    func deleteChatRoom(chatRoomId: Int64, completion: @escaping (Result<Void, DeleteChatRoomError>) -> Void) { repository.deleteChatRoom(chatRoomId: chatRoomId, completion: completion)
    }

    func deleteChatRoomByAdmin(chatRoomId: Int64, completion: @escaping (Result<Void, DeleteChatRoomError>) -> Void) { repository.deleteChatRoomByAdmin(chatRoomId: chatRoomId, completion: completion)
    }
}
    