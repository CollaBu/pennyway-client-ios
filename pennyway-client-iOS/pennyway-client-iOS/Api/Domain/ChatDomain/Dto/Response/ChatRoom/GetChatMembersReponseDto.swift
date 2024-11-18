//
//  GetChatMembersReponseDto.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/16/24.
//

import Foundation

struct GetChatMembersReponseDto: Codable {
    let code: String
    let data: GetChatMembers

    struct GetChatMembers: Codable {
        let chatMembers: [GetChatMember]
    }

    static func to(dto: GetChatMembersReponseDto) -> [ChatMember] {
        let members = dto.data.chatMembers.map { member in
            ChatMember(id: member.id, userId: member.userId, name: member.name, role: member.role, notifyEnabled: member.notifyEnabled, createdAt: member.createdAt, profileImage: "")
        }

        return members
    }
}
