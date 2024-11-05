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
    let otherParticipantIds: [Int64]
    let recentMessages: [Message]
}

// MARK: - ChatUserInfo

struct ChatUserInfo: Equatable {
    let id: Int64
    let name: String
    let role: Role
    let notifyEnabled: Bool
    let createdAt: String
}
