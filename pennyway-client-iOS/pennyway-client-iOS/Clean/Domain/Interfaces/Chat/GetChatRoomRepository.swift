//
//  GetChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/24/24.
//

import Foundation

/// 내 채팅방 조회 동작을 정의하는 프로토콜
protocol GetChatRoomRepository {
    /// 내 채팅방 조회하는 함수
    func getChatRoom(completion: @escaping (Result<[ChatRoom], any Error>) -> Void)
}
