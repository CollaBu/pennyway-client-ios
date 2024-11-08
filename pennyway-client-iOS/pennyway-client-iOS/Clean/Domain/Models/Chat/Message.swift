//
//  Message.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import Foundation

// MARK: - Message

struct Message: Equatable {
    let chatRoomId: Int64
    let chatId: Int64
    let content: String
    let contentType: ContentType
    let categoryType: CategoryType
    let createdAt: String
    let senderId: Int64
}
