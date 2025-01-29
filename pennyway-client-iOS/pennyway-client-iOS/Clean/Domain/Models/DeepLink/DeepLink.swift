//
//  DeepLink 2.swift
//  pennyway-client-iOS
//
//  Created by 신얀 on 1/20/25.
//

// MARK: - DeepLink

struct DeepLink {
    let target: DeepLinkTarget
    let parameters: [String: String]
}

// MARK: - DeepLinkTarget

enum DeepLinkTarget {
    ///    case userProfile(userId: String)
    case chatRoom(chatRoomId: String)
}
