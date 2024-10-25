//
//  SearchChatRoomResponseDto.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/26/24.
//

import Foundation

import Foundation

// MARK: - SearchChatRoomResponseDto

struct SearchChatRoomResponseDto: Codable {
    let code: String
    let data: ChatRooms
}

// MARK: - ChatRooms
struct ChatRooms: Codable {
    let chatRooms: ChatRoomsContent
}

// MARK: - ChatRoomsContent
struct ChatRoomsContent: Codable {
    let contents: [ChatRoomContent]
    let currentPageNumber: Int32
    let pageSize: Int32
    let numberOfElements: Int32
    let hasNext: Bool
}

// MARK: - ChatRoomContent
struct ChatRoomContent: Codable {
    let description: String
}

