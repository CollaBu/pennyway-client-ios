//
//  ChatRoomItemModel.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/24/24.
//

import Foundation

// MARK: - ChatRoom

struct ChatRoom: Equatable {
    let chatRoom: ChatRoomItemModel
}

// MARK: - ChatRoomItemModel

struct ChatRoomItemModel: Equatable {
    var title: String
    var description: String
    var backgroundImageUrl: String
    var isPrivate: Bool
    var isAdmin: Bool
    var participantCount: Int32
}
