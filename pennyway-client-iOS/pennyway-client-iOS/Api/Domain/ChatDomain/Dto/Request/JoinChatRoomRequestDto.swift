//
//  JoinChatRoomRequestDto.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/6/24.
//

public struct JoinChatRoomRequestDto: Encodable {
    let password: String?
    let name: String

    public init(
        password: String? = nil,
        name: String
    ) {
        self.password = password
        self.name = name
    }
}
