//
//  SearchChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/2/24.
//

/// 채팅방 검색 동작을 정의하는 프로토콜
protocol SearchChatRoomRepository {
    func execute(model: SearchChatRoom, completion: @escaping (Result<[ChatRoom], any Error>) -> Void) 
}
