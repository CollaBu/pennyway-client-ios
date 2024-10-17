//
//  PresignedUrl.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/20/24.
//

import Foundation

// MARK: - PresignedUrl

struct PresignedUrl {
    let presignedUrl: String
}

// MARK: - PresignedUrlType

struct PresignedUrlType {
    let type: String
    let ext: String
    let chatRoomId: Int64?
}
