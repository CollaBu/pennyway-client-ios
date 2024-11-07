//
//  GetChatRoomDetailResponseDto.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Foundation

// MARK: - GetChatRoomDetailResponseDto

struct GetChatRoomDetailResponseDto: Codable {
    let code: String
    let data: GetChatRoom

    struct GetChatRoom: Codable {
        let chatRoom: GetChatRoomDetail

        struct GetChatRoomDetail: Codable {
            let myInfo: GetChatMember
            let recentParticipants: [GetChatMember]
            let otherParticipants: [GetOtherMember]
            let recentMessages: [GetMessage]

            struct GetOtherMember: Codable {
                let id: Int64
                let name: String
            }

            struct GetChatMember: Codable {
                let id: Int64
                let userId: Int64
                let name: String
                let role: Role
                let notifyEnabled: Bool?
                let createdAt: String
            }
        }
    }

    static func to(dto: GetChatRoomDetailResponseDto) -> ChatRoomDetailInfo {
        return ChatRoomDetailInfo(
            myInfo: ChatMember(
                id: dto.data.chatRoom.myInfo.id,
                userId: dto.data.chatRoom.myInfo.userId,
                name: dto.data.chatRoom.myInfo.name,
                role: dto.data.chatRoom.myInfo.role,
                notifyEnabled: dto.data.chatRoom.myInfo.notifyEnabled,
                createdAt: dto.data.chatRoom.myInfo.createdAt, 
                profileImage: ""
            ),
            recentParticipants: dto.data.chatRoom.recentParticipants.map {
                ChatMember(
                    id: $0.id,
                    userId: $0.userId,
                    name: $0.name,
                    role: $0.role,
                    notifyEnabled: $0.notifyEnabled,
                    createdAt: $0.createdAt,
                    profileImage: ""
                )
            },
            otherParticipants: dto.data.chatRoom.otherParticipants.map {
                OtherMember(
                    id: $0.id, 
                    name: $0.name
                )
            },
            recentMessages: dto.data.chatRoom.recentMessages.map {
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

// MARK: - GetMessage

struct GetMessage: Codable {
    let chatRoomId: Int64
    let chatId: Int64
    let content: String
    let contentType: ContentType
    let categoryType: CategoryType
    let createdAt: String
    let senderId: Int64

    /// json -> GetMessage 타입으로 반환
    static func parseGetMessage(from json: String) -> Result<GetMessage, Error> {
        guard let jsonData = json.data(using: .utf8) else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON string"]))
        }

        do {
            let getMessage = try JSONDecoder().decode(GetMessage.self, from: jsonData)
            return .success(getMessage)
        } catch {
            return .failure(error)
        }
    }

    static func toItemModel(dto: GetMessage) -> MessageItemModel {
        return MessageItemModel(chatRoomId: dto.chatRoomId, chatId: dto.chatId, content: dto.content, contentType: dto.contentType, categoryType: dto.categoryType, createdAt: dto.createdAt, senderId: dto.senderId)
    }
}
