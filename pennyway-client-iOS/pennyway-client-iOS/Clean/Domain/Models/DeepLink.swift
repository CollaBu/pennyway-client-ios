//
//  DeepLink.swift
//  pennyway-client-iOS
//
//  Created by 신얀 on 2/2/25.
//

import Foundation

// MARK: - DeepLink

struct DeepLink {
    let target: DeepLinkTarget
    let parameters: [String: String]
}

// MARK: - DeepLinkTarget

enum DeepLinkTarget {
    case chatRoom(chatRoomId: String)
}
