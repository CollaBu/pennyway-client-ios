//
//  ChatRoomDetailInfo.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Foundation

// MARK: - ChatRoomDetailInfo

struct ChatRoomDetailInfo: Equatable {
    let myInfo: ChatUserInfo // 내 정보
    let recentParticipants: [ChatUserInfo] // 최근에 메시지를 보낸 사용자
    let otherParticipantIds: [Int64] // 최근에 메시지를 보내지 않았지만 단톡방에 속해있는 사용자
    let recentMessages: [Message] // 최근 메시지 내용 15개
}

// MARK: - ChatUserInfo

struct ChatUserInfo: Equatable {
    let id: Int64
    let name: String
    let role: Role
    let notifyEnabled: Bool
    let createdAt: String
}
