//
//  EditChatRoomResponseDto.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/16/25.
//

struct EditChatRoomResponseDto: Codable {
    let code: String
    let data: EditChatRoomData
    
    struct EditChatRoomData: Codable {
        let chatRoom: [ChatRoomDetail]
    }
}
