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
    @Published var currentChatRoomId: Int64?
    private let navigationState = ChatNavigationState.shared

    func handleDeepLink(url: URL) {
        guard url.scheme == "pennyway",
              url.host == "chat",
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItem = components.queryItems?.first(where: { $0.name == "roomId" }),
              let roomId = queryItem.value,
              let chatRoomId = Int64(roomId)
        else {
            Log.fault("⚠️ Failed to parse deep link URL: \(url)")
            return
        }

        Log.info("✅ DeepLink detected: Moving to chatRoomId: \(chatRoomId)")

        DispatchQueue.main.async {
            self.currentChatRoomId = chatRoomId
            self.navigateToChatRoom(chatRoomId: chatRoomId)
        }
    }

    private func navigateToChatRoom(chatRoomId: Int64) {
        DispatchQueue.main.async {
            self.currentChatRoomId = chatRoomId
            self.navigationState.navigateToChatRoom(id: chatRoomId)
            Log.info("[DeepLinkCoordinator]:🌐 Navigate to ChatRoom with ID: \(chatRoomId)")
        }
    }
}
