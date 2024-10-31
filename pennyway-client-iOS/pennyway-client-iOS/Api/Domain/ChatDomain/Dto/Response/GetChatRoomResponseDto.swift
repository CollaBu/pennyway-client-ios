//
//  GetChatRoomResponseDto.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/31/24.
//

// MARK: - GetChatRoomResponseDto

struct GetChatRoomResponseDto: Codable {
    let code: String
    let data: ChatRoomData
}

// MARK: - ChatRoomData

struct ChatRoomData: Codable {
    let chatRooms: [ChatRoomDetail]
}

// MARK: - ChatRoomDetail

struct ChatRoomDetail: Codable {
    let id: Int64
    let title: String
    let description: String
    let backgroundImageUrl: String
    let isPrivate: Bool
    let isAdmin: Bool
    let participantCount: Int32
    let createdAt: String?
}
