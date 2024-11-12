//
//  SearchChatRoomItemModel.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/2/24.
//

import Foundation

// MARK: - SearchChatRoomItemModel

struct SearchChatRoomItemModel: Equatable, Identifiable, ChatRoomProtocol {
    var id: Int
    var title: String
    var description: String
    var isPrivate: Bool
    var backgroundImageUrl: String
    var participantCount: Int32
}
