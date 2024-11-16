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
}
