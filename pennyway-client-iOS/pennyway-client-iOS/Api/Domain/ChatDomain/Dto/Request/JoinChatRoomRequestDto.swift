//
//  JoinChatRoomRequestDto.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/6/24.
//

public struct JoinChatRoomRequestDto: Encodable {
    let password: String

    public init(password: String) {
        self.password = password
    }
}
