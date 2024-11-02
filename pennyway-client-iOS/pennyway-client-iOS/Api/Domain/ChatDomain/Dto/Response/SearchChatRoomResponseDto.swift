//
//  SearchChatRoomResponseDto.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/26/24.
//

import Foundation

// MARK: - SearchChatRoomResponseDto

struct SearchChatRoomResponseDto: Codable {
    let code: String
    let data: SearchChatRoomData
}

// MARK: - SearchChatRoomData

struct SearchChatRoomData: Codable {
    let chatRooms: SearchChatRoomsContent
}

// MARK: - SearchChatRoomsContent

struct SearchChatRoomsContent: Codable {
    let contents: [ChatRoomDetail]
    let currentPageNumber: Int32
    let pageSize: Int32
    let numberOfElements: Int32
    let hasNext: Bool
}
