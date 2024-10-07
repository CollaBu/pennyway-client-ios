//
//  Chat.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import Foundation

struct ChatRoom: Equatable, Identifiable {
    let id: Int64
    let title: String
    let description: String
    let background_image_url: String
    let password: String?
    let privacy_setting: Bool
    let notify_enabled: Bool
}

struct Chat: Equatable, Identifiable {
    let id: Int64
    let content: String
    let created_at: Date
    let sender_id: Int64
    let chat_room_id: Int64
}

struct ChatMember: Equatable, Identifiable {
    let id: Int64
    let profile_image: String
    let username: String
    let role: String
    let user_id: Int64
    let chat_room_id: Int64
}
