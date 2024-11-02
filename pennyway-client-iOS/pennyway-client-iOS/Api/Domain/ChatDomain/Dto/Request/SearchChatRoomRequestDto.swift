//
//  SearchChatRoomRequestDto.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/26/24.
//

public struct SearchChatRoomRequestDto: Encodable {
    let target: Int
    let page: Int

    public init(
        target: Int,
        page: Int
    ) {
        self.target = target
        self.page = page
    }
}
