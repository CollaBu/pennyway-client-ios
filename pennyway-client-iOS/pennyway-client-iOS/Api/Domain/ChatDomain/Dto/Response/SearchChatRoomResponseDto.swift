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
    let data: SearchChatRoomData
}

// MARK: - SearchChatRoomData
struct SearchChatRoomData: Codable {
    let chatRooms: SearchChatRoomsContent
}

// MARK: - SearchChatRoomsContent
struct SearchChatRoomsContent: Codable {
    let contents: [SearchChatRoomContent]
    let currentPageNumber: Int32
    let pageSize: Int32
    let numberOfElements: Int32
    let hasNext: Bool
}

// MARK: - SearchChatRoomContent
struct SearchChatRoomContent: Codable {
    let description: String
}

