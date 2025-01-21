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
}
