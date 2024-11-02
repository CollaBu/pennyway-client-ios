//
//  SearchChatRoomUseCase.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/2/24.
//

import Foundation

/// 채팅방 검색 usecase를 정의하는 프로토콜
protocol SearchChatRoomUseCase {
    func searchChatRoom(completion: @escaping (Result<String, Error>) -> Void)
}
