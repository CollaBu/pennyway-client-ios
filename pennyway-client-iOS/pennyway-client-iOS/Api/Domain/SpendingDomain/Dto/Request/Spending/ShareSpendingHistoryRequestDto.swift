//
//  ShareSpendingHistoryRequestDto.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 2/4/25.
//

import Foundation

public struct ShareSpendingHistoryRequestDto: Encodable {
    let type: String
    let year: Int
    let month: Int
    let day: Int
    let chatRoomIds: [Int64]

    public init(
        type: String,
        year: Int,
        month: Int,
        day: Int,
        chatRoomIds: [Int64]
    ) {
        self.type = type
        self.year = year
        self.month = month
        self.day = day
        self.chatRoomIds = chatRoomIds
    }
}
