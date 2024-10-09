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
    let background_image_url: String
    let password: String?
    let privacy_setting: Bool
    let notify_enabled: Bool
}
