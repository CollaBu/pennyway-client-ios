//
//  Value.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 5/31/24.
//

import Foundation

// MARK: - MaxValue

enum MaxValue {
    static let maxValue: Int = 2_147_483_647
}

// MARK: - VerificationType

enum VerificationType: String {
    case general = "GENERAL"
    case oauth = "OAUTH"
    case username = "USERNAME"
    case password = "PASSWORD"
    case phone = "PHONE"
}

// MARK: - ImageType

enum ImageType: String {
    case profile = "PROFILE"
    case feed = "FEED"
    case chatroomProfile = "CHATROOM_PROFILE"
    case caht = "CHAT"
    case chatProfile = "CHAT_PROFILE"
}

// MARK: - Ext

enum Ext: String {
    case jpg = "jpg"
    case png = "png"
    case jpeg = "jpeg"
}

/// 연결타입
enum ConnectionType {
    case wifi
    case cellular
    case ethernet
    case unknown
}
