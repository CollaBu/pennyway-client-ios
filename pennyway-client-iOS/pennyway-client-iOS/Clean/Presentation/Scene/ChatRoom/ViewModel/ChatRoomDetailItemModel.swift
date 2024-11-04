//
//  ChatRoomDetailItemModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Foundation

// MARK: - ChatRoomDetailItemModel

struct ChatRoomDetailItemModel {
    var myInfo: ChatUserInfoItemModel
    var recentParticipants: [ChatUserInfoItemModel]
    var otherParticipantIds: [Int64]
    var recentMessages: [MessageItemModel]

    static func from(model: ChatRoomDetailInfo) -> ChatRoomDetailItemModel {
        return ChatRoomDetailItemModel(
            myInfo: ChatUserInfoItemModel(
                id: model.myInfo.id,
                name: model.myInfo.name,
                role: model.myInfo.role,
                notifyEnabled: model.myInfo.notifyEnabled,
                createdAt: model.myInfo.createdAt
            ),
            recentParticipants: model.recentParticipants.map {
                ChatUserInfoItemModel(
                    id: $0.id,
                    name: $0.name,
                    role: $0.role,
                    notifyEnabled: $0.notifyEnabled,
                    createdAt: $0.createdAt
                )
            },
            otherParticipantIds: model.otherParticipantIds,
            recentMessages: model.recentMessages.map {
                MessageItemModel(
                    chatRoomId: $0.chatRoomId,
                    chatId: $0.chatId,
                    content: $0.content,
                    contentType: $0.contentType,
                    categoryType: $0.categoryType,
                    createdAt: $0.createdAt,
                    senderId: $0.senderId
                )
            }
        )
    }
}

// MARK: - ChatUserInfoItemModel

struct ChatUserInfoItemModel: Equatable {
    var id: Int64
    var name: String
    var role: Role
    var notifyEnabled: Bool
    var createdAt: String
}

// MARK: - MessageItemModel

struct MessageItemModel: Equatable {
    var chatRoomId: Int64
    var chatId: Int64
    var content: String
    var contentType: ContentType
    var categoryType: CategoryType
    var createdAt: String
    var senderId: Int64
}
