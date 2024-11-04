//
//  GetChatRoomDetailResponseDto.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Foundation


struct GetChatRoomDetailResponseDto: Codable {
    let code: String
    let data: GetChatRoomDetail

    struct GetChatRoomDetail: Codable {
        let myInfo: GetChatUserInfo
        let recentParticipants: [GetChatUserInfo]
        let otherParticipantIds: [Int64]
        let recentMessages: [GetMessage]
        

        struct GetChatUserInfo: Codable {
            let id: Int64
            let name: String
            let role: Role
            let notifyEnabled: Bool
            let createdAt: String
        }
        
        struct GetMessage: Codable {
            let chatRoomId: Int64
            let chatId: Int64
            let content: String
            let contentType: ContentType
            let categoryType: CategoryType
            let createdAt: String
            let senderId: Int64
        }
    }
    
    static func to(dto: GetChatRoomDetailResponseDto) -> ChatRoomDetailInfo {
        return ChatRoomDetailInfo(
            myInfo: ChatUserInfo(
                id: dto.data.myInfo.id,
                name: dto.data.myInfo.name,
                role: dto.data.myInfo.role,
                notifyEnabled: dto.data.myInfo.notifyEnabled,
                createdAt: dto.data.myInfo.createdAt
            ),
            recentParticipants: dto.data.recentParticipants.map {
                ChatUserInfo(
                    id: $0.id,
                    name: $0.name,
                    role: $0.role,
                    notifyEnabled: $0.notifyEnabled,
                    createdAt: $0.createdAt
                )
            },
            otherParticipantIds: dto.data.otherParticipantIds,
            recentMessages: dto.data.recentMessages.map {
                Message(
                    chatRoomId: $0.chatRoomId,
                    chatId: $0.chatId,
                    content: $0.content,
                    contentType: $0.contentType,
                    categoryType: $0.categoryType,
                    createdAt: $0.createdAt,
                    senderId: $0.senderId
                )
            }
        )
    }
}
