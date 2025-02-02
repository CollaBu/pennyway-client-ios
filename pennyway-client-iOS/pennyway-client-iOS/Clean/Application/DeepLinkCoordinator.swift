//
//  DeepLinkCoordinator.swift
//  pennyway-client-iOS
//
//  Created by 신얀 on 2/2/25.
//

import Foundation

// MARK: - FlowCoordinatorProtocol

protocol FlowCoordinatorProtocol {
    func chatRoomFlowStart(chatRoomId: String)
}

// MARK: - DeepLinkCoordinator

final class DeepLinkCoordinator: ObservableObject {
    @Published var currentChatRoomId: String?

    func handle(deepLink: DeepLink) {
        switch deepLink.target {
        case let .chatRoom(chatRoomId):
            currentChatRoomId = chatRoomId
        }
    }
}
