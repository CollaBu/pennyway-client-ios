//
//  ChatMember.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/9/24.
//

import Foundation

// MARK: - ChatMember

struct ChatMember: Equatable, Identifiable {
    let id: Int64
    let profile_image: String
    let username: String
    let role: String
    let user_id: Int64
    let chat_room_id: Int64
}
