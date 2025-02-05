//
//  ShareToChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 2/4/25.
//

import Foundation

protocol ShareToChatRoomRepository {
    func shareToChatRoom(date: Date, chatRoomIds: [Int64], completion: @escaping (Bool) -> Void)
}
