//
//  ChatRoomDetailInfo.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Foundation

struct ChatRoomDetailInfo: Equatable {
    let myInfo: ChatUserInfo
    let recentParticipants: [ChatUserInfo]
    let otherParticipantIds: [Int]
    let recentMessages: [Message]
}

struct ChatUserInfo: Equatable {
    let id: Int
    let name: String
    let role: Role
    let notifyEnabled: Bool
    let createdAt: String
}

struct Message: Equatable {
    let chatRoomId: Int
    let chatId: Int
    let content: String
    let contentType: ContentType
    let categoryType: CategoryType
    let createdAt: String
    let senderId: Int
}

enum Role: String{
    case admin = "ADMIN"
    case user = "MEMBER"
}

enum ContentType: String{
    case text = "TEXT"
    case image = "IMAGE"
    case video = "VIDEO"
    case file = "FILE"
}

enum CategoryType: String{
    case normal = "NORMAL"
    case important = "SYSTEM"
}
