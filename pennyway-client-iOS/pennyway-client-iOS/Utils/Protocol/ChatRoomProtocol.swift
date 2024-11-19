//
//  ChatRoomProtocol.swift
//  pennyway-client-iOS
//
//  Created by 최희진, 아우신얀 on 11/3/24.
//

/// ChatRoomCell 컴포넌트에 필요한 채팅방 정보들
protocol ChatRoomProtocol {
    var id: Int64 { get }
    var title: String { get }
    var description: String { get }
    var isPrivate: Bool { get }
    var participantCount: Int32 { get }
    var backgroundImageUrl: String { get }
    var lastMassage: LastMessage? { get }
    var unreadMessageCount: Int64 { get }
}
