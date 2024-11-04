//
//  ChatRoomDetailItemModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Foundation

struct ChatRoomDetailItemModel {
    let myInfo: ChatUserInfo
    let recentParticipants: [ChatUserInfo]
    let otherParticipantIds: [Int]
    let recentMessages: [Message]
}
