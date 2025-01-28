//
//  DefaultUserInfoRepository.swift
//  pennyway-client-iOS
//
//  Created by 신얀 on 1/20/25.
//

import Foundation

class DefaultUserInfoRepository: UserInfoRepository {
    func banChatMember(chatRoomId: Int64, chatMemberId: Int64, completion: @escaping (Bool) -> Void) {
        ChatRoomAlamofire.shared.banChatMember(chatRoomId, chatMemberId) { result in
            switch result {
            case let .success(data):
                Log.debug("[DefaultUserInfoRepository]: 채팅멤버 강제 추방 성공")
                completion(true)
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(false)
            }
        }
    }
    
    func delegateToAdmin(chatRoomId: Int64, chatMemberId: Int64, completion: @escaping (Bool) -> Void) {
        ChatRoomAlamofire.shared.delegateToAdmin(chatRoomId, chatMemberId) { result in
            switch result {
            case let .success(data):
                Log.debug("[DefaultUserInfoRepository]: 관리자 위임 성공")
                completion(true)
            case let .failure(error):
                // 4033에러
                if let statusSpecificError = error as? StatusSpecificError,
                   statusSpecificError.domainError == .forbidden,
                   statusSpecificError.code == ForbiddenErrorCode.accessNotAllowedForUserRole.rawValue
                {
                    completion(.failure(DeleteChatRoomError.notAdmin))
                }

                // 4040에러
                if let statusSpecificError = error as? StatusSpecificError,
                   statusSpecificError.domainError == .notFound,
                   statusSpecificError.code == NotFoundErrorCode.resourceNotFound.rawValue
                {
                    completion(.failure(DeleteChatRoomError.notFound))
                }

                // 4090 에러
                if let statusSpecificError = error as? StatusSpecificError,
                   statusSpecificError.domainError == .conflict,
                   statusSpecificError.code == ConflictErrorCode.requestConflictWithResourceState.rawValue
                {
                    completion(.failure(DeleteChatRoomError.mismatchConflict))
                }
                
                else {
                    completion(.failure(DeleteChatRoomError.other(error)))
                }
            }
        }
    }
}
