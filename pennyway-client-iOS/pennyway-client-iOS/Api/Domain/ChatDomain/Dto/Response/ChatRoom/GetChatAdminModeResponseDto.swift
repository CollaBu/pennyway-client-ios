//
//  GetChatAdminModeResponseDto.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/22/25.
//

import Foundation


struct GetChatAdminModeResponseDto: Codable {
    let code: String
    let data: GetChatRoom
    
    struct GetChatRoom: Codable {
        let chatRoom: GetChatAdminModeDto
        
    }
}

struct GetChatAdminModeDto: Codable {
    let id: Int64
    let title: String
    let description: String
    let backgroundImageUrl: String
    let password: Int32
}
