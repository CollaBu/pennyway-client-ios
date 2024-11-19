//
//  GetChatMembersRequestDto.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/16/24.
//

import Foundation

public struct GetChatMembersRequestDto: Encodable {
    let ids: [Int64]

    public init(
        ids: [Int64]
    ) {
        self.ids = ids
    }
}
