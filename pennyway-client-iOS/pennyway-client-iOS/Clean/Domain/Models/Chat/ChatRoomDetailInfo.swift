//
//  ChatRoomDetailInfo.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Foundation

// MARK: - ChatRoomDetailInfo

struct ChatRoomDetailInfo: Equatable {
    let myInfo: ChatUserInfo
    let recentParticipants: [ChatUserInfo]
    let otherParticipantIds: [Int]
    let recentMessages: [Message]
}

// MARK: - ChatUserInfo

struct ChatUserInfo: Equatable {
    let id: Int
    let name: String
    let role: Role
    let notifyEnabled: Bool
    let createdAt: String
}

// MARK: - Message

struct Message: Equatable {
    let chatRoomId: Int
    let chatId: Int
    let content: String
    let contentType: ContentType
    let categoryType: CategoryType
    let createdAt: String
    let senderId: Int
}

// MARK: - Role

enum Role: String {
    case admin = "ADMIN"
    case user = "MEMBER"
}

// MARK: - ContentType

enum ContentType: String {
    case text = "TEXT"
    case image = "IMAGE"
    case video = "VIDEO"
    case file = "FILE"
}

// MARK: - CategoryType

enum CategoryType: String {
    case normal = "NORMAL"
    case important = "SYSTEM"
}
