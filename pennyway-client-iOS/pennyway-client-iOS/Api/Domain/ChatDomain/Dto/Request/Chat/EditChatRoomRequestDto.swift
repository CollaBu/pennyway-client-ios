//
//  EditChatRoomRequestDto.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/16/25.
//

// MARK: - EditChatRoomRequestDto

public struct EditChatRoomRequestDto: Encodable {
    let title: String
    let description: String?
    let password: String?
    let backgroundImageUrl: String?

    public init(
        title: String,
        description: String? = nil,
        password: String? = nil,
        backgroundImageUrl: String? = nil
    ) {
        self.title = title
        self.description = description
        self.password = password
        self.backgroundImageUrl = backgroundImageUrl
    }
}
