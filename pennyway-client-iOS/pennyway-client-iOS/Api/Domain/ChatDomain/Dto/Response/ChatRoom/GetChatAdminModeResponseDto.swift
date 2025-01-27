//
//  GetChatAdminModeResponseDto.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/22/25.
//

import Foundation

struct GetChatAdminModeResponseDto: Codable, MakeFullImageURL {
    let code: String
    let data: GetChatRoom

    struct GetChatRoom: Codable {
        let chatRoom: GetChatAdminModeDto
    }

    struct GetChatAdminModeDto: Codable {
        let id: Int64
        let title: String
        let description: String?
        let backgroundImageUrl: String?
        let password: Int32?
    }

    static func to(dto: GetChatAdminModeResponseDto, cdnUrl: String) -> AdminModeChatRoom {
        var completeBackgroundImageUrl: String? = nil

        if let imageUrl = dto.data.chatRoom.backgroundImageUrl {
            completeBackgroundImageUrl = createFullURL(with: cdnUrl, pathComponent: imageUrl)
        }

        return AdminModeChatRoom(
            id: dto.data.chatRoom.id,
            title: dto.data.chatRoom.title,
            description: dto.data.chatRoom.description,
            backgroundImageUrl: completeBackgroundImageUrl,
            password: dto.data.chatRoom.password)
    }
}
