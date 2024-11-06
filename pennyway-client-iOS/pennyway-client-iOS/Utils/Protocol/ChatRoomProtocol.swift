//
//  ChatRoomProtocol.swift
//  pennyway-client-iOS
//
//  Created by 최희진, 아우신얀 on 11/3/24.
//

/// 내 채팅과 추천채팅에서 보여지는 공통 컴포넌트를 모아놓은 프로토콜
protocol ChatRoomProtocol {
    var id: Int64 { get }
    var title: String { get }
    var description: String { get }
    var isPrivate: Bool { get }
    var participantCount: Int32 { get }
    var backgroundImageUrl: String { get }
}
