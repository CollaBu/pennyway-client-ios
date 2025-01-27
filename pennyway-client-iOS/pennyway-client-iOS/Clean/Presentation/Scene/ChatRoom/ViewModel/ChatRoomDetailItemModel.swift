//
//  ChatRoomDetailItemModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Foundation

// MARK: - ChatRoomDetailItemModel

struct ChatRoomDetailItemModel {
    var myInfo: ChatMemberItemModel
    var recentParticipants: [ChatMemberItemModel]
    var otherParticipants: [OtherMemberItemModel]
    var recentMessages: [MessageItemModel]

    
    static func from(model: ChatRoomDetailInfo) -> ChatRoomDetailItemModel {
        return ChatRoomDetailItemModel(
            myInfo: ChatMemberItemModel(
                id: model.myInfo.id,
                userId: model.myInfo.userId,
                name: model.myInfo.name,
                role: model.myInfo.role,
                notifyEnabled: model.myInfo.notifyEnabled,
                createdAt: model.myInfo.createdAt, 
                profileImage: model.myInfo.profileImage
            ),
            recentParticipants: model.recentParticipants.map {
                ChatMemberItemModel(
                    id: $0.id,
                    userId: $0.userId,
                    name: $0.name,
                    role: $0.role,
                    notifyEnabled: $0.notifyEnabled,
                    createdAt: $0.createdAt, 
                    profileImage: $0.profileImage
                )
            },
            otherParticipants: model.otherParticipants.map {
                OtherMemberItemModel(
                    id: $0.id,
                    name: $0.name
                )
            },
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

// MARK: - OtherMemberItemModel

struct OtherMemberItemModel: Equatable, Identifiable {
    let id: Int64
    let name: String
}

// MARK: - ChatMemberItemModel

struct ChatMemberItemModel: Equatable, Identifiable {
    var id: Int64
    var userId: Int64
    var name: String
    var role: Role
    var notifyEnabled: Bool?
    var createdAt: String
    let profileImage: String?

    static func from(model: [ChatMember]) -> [ChatMemberItemModel] {
        let members = model.map { member in
            ChatMemberItemModel(id: member.id, userId: member.userId, name: member.name, role: member.role, notifyEnabled: member.notifyEnabled, createdAt: member.createdAt, profileImage: member.profileImage)
        }

        return members
    }
}

// MARK: - MessageItemModel

struct MessageItemModel: Equatable, Identifiable {
    var id: Int64 { chatId }
    var chatRoomId: Int64
    var chatId: Int64
    var content: String
    var contentType: ContentType
    var categoryType: CategoryType
    var createdAt: String
    var senderId: Int64
}
