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
    case chat = "CHAT"
    case chatProfile = "CHAT_PROFILE"
}

// MARK: - Ext

enum Ext: String {
    case jpg
    case png
    case jpeg
}

// MARK: - ConnectionType

/// 연결타입
enum ConnectionType {
    case wifi
    case cellular
    case ethernet
    case unknown
}

// MARK: - Role

enum Role: String, Codable {
    case admin = "ADMIN"
    case user = "MEMBER"
}

// MARK: - ContentType

enum ContentType: String, Codable {
    case text = "TEXT"
    case image = "IMAGE"
    case video = "VIDEO"
    case file = "FILE"
}

// MARK: - CategoryType

enum CategoryType: String, Codable {
    case normal = "NORMAL"
    case system = "SYSTEM"
    case share = "SHARE"
}

// MARK: - ChatRoomAlarmType

enum ChatRoomAlarmType {
    case on
    case off
}
