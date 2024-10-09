//
//  Chat.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/8/24.
//

import Foundation

// MARK: - Chat

struct Chat: Equatable, Identifiable {
    let id: Int64
    let content: String
    let created_at: Date
    let sender_id: Int64
    let chat_room_id: Int64
}
