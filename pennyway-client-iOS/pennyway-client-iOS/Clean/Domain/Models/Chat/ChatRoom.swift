//
//  ChatRoom.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/9/24.
//

import Foundation

// MARK: - ChatRoom

struct ChatRoom: Equatable, Identifiable {
    let id: Int64
    let title: String
    let description: String
    let backgroundImageUrl: String
    let isPrivate: Bool
    let isAdmin: Bool
    let participantCount: Int32
    let createdAt: String
    let lastMassage: Message?
    let unreadMessageCount: Int64
}

// MARK: - AdminModeChatRoom

struct AdminModeChatRoom: Equatable, Identifiable {
    let id: Int64
    let title: String
    let description: String?
    let backgroundImageUrl: String?
    let password: Int32?

    static func to(model: AdminModeChatRoom) -> AdminModeChatRoomItemModel {
        var password: String? = nil

        if model.password != nil {
            password = String(model.password!)
        }

        return AdminModeChatRoomItemModel(chatRoomId: model.id, title: model.title, description: model.description, password: password, backgroundImageUrl: model.backgroundImageUrl)
    }
}
