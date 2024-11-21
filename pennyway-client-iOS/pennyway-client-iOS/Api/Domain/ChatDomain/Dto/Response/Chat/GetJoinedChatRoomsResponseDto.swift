//
//  GetJoinedChatRoomsResponseDTO.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/1/24.
//

import Foundation

struct GetJoinedChatRoomsResponseDto: Decodable {
    let code: String
    let data: ChatRoomDataDto

    struct ChatRoomDataDto: Decodable {
        let chatRoom: ChatRoomDto
    }

    struct ChatRoomDto: Decodable {
        let chatRoomIds: [Int64]
    }
}
