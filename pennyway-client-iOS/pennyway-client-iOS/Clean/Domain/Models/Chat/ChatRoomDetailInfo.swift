//
//  ChatRoomDetailInfo.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Foundation

// MARK: - ChatRoomDetailInfo

struct ChatRoomDetailInfo: Equatable {
    let myInfo: ChatMember // 내 정보
    let recentParticipants: [ChatMember] // 최근에 메시지를 보낸 사용자
    let otherParticipants: [OtherMember] // 최근에 메시지를 보내지 않았지만 단톡방에 속해있는 사용자
    let recentMessages: [Message] // 최근 메시지 내용 15개
}
