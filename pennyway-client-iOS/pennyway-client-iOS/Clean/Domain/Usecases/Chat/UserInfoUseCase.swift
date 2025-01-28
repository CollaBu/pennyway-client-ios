//
//  UserInfoUseCase.swift
//  pennyway-client-iOS
//
//  Created by 신얀 on 1/20/25.
//

// MARK: - UserInfoUseCase

protocol UserInfoUseCase {
    func banChatMember(chatRoomId: Int64, chatMemberId: Int64, completion: @escaping (Bool) -> Void)
    func delegateToAdmin(chatRoomId: Int64, chatMemberId: Int64, completion: @escaping (Result<Void, DeleteChatRoomError>) -> Void)
}

// MARK: - DefaultUserInfoUseCase

class DefaultUserInfoUseCase: UserInfoUseCase {
    private let repository: UserInfoRepository

    init(repository: UserInfoRepository) {
        self.repository = repository
    }

    /// 채팅 멤버 강제 추방
    func banChatMember(chatRoomId: Int64, chatMemberId: Int64, completion: @escaping (Bool) -> Void) {
        repository.banChatMember(chatRoomId: chatRoomId, chatMemberId: chatMemberId) { success in
            if success {
                let isSuccess = true
                Log.debug("[DefaultUserInfoUseCase]: 채팅멤버 강제 추방 성공")
                completion(isSuccess)
            } else {
                Log.error("[DefaultUserInfoUseCase]: 채팅멤버 강제 추방 실패")
            }
        }
    }
    
    /// 관리자 위임
    func delegateToAdmin(chatRoomId: Int64, chatMemberId: Int64, completion: @escaping (Result<Void, DeleteChatRoomError>) -> Void) {
        repository.delegateToAdmin(chatRoomId: chatRoomId, chatMemberId: chatMemberId, completion: completion)
    }
}
