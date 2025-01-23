//
//  EditChatRoomRequestDto.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/16/25.
//

// MARK: - EditChatRoomRequestDto

public struct EditChatRoomRequestDto: Encodable {
    let chatRoomId: Int64
    let title: String
    let description: String?
    let password: String?
    let backgroundImageUrl: String?

    public init(
        chatRoomId: Int64,
        title: String,
        description: String? = nil,
        password: String? = nil,
        backgroundImageUrl: String? = nil
    ) {
        self.chatRoomId = chatRoomId
        self.title = title
        self.description = description
        self.password = password
        self.backgroundImageUrl = backgroundImageUrl
    }
}
