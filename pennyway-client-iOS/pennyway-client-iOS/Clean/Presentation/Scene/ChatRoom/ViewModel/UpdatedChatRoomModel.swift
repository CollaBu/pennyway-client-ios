//
//  UpdatedChatRoomModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/30/25.
//

import Foundation

/// 기존 데이터를 유지하면서 특정 값만 변경할 수 있도록 하는 구조체
struct UpdatedChatRoomModel: ChatRoomProtocol {
    var id: Int64
    var title: String
    var description: String
    var isPrivate: Bool
    var participantCount: Int32
    var backgroundImageUrl: String
    var lastMassage: MessageItemModel?
    var unreadMessageCount: Int64

    init(original: ChatRoomProtocol, title: String, description: String, isPrivate: Bool, backgroundImageUrl: String) {
        id = original.id
        self.title = title
        self.description = description
        self.isPrivate = isPrivate
        participantCount = original.participantCount
        self.backgroundImageUrl = backgroundImageUrl
        lastMassage = original.lastMassage
        unreadMessageCount = original.unreadMessageCount
    }
}
