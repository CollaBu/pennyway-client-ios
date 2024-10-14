//
//  MakeChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/15/24.
//

import Foundation

/// 채팅방 생성 동작을 정의하는 프로토콜
protocol MakeChatRoomRepository {
    /// 채팅방 생성하는 함수
    func makeChatRoom(completion: @escaping (Bool) -> Void)
}
