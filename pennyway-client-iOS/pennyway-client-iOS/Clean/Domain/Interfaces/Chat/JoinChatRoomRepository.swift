//
//  JoinChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/6/24.
//

import Foundation

/// 채팅방 가입 동작을 정의하는 프로토콜
protocol JoinChatRoomRepository {
    func joinChatRoom(chatRoomId: Int64, password: String, completion: @escaping (Result<ChatRoom, any Error>) -> Void)
}
