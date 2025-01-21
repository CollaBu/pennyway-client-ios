//
//  UserInfoRepository.swift
//  pennyway-client-iOS
//
//  Created by 신얀 on 1/20/25.
//

import Foundation

/// 채팅방 멤버에 대한 기능을 정의하는 프로토콜
protocol UserInfoRepository {
    /// 채팅멤버를 강제추방 하는 함수
    func banChatMember(chatRoomId: Int64, chatMemberId: Int64, completion: @escaping (Bool) -> Void)
}
