//
//  GetChatServerResponseDto.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/16/24.
//

import Foundation

struct GetChatServerResponseDto: Codable {
    let code: String
    let data: ChatServerUrl

    struct ChatServerUrl: Codable {
        let chatServerUrl: String
    }
}
