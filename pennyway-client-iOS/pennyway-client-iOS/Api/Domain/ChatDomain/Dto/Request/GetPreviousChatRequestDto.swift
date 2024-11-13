//
//  GetChatDataRequestDto.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/13/24.
//

import Foundation

public struct GetPreviousChatRequestDto: Encodable {
    let lastMessageId: Int64

    public init(
        lastMessageId: Int64
    ) {
        self.lastMessageId = lastMessageId
    }
}
