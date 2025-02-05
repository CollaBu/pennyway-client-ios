//
//  ChatNavigationState.swift
//  pennyway-client-iOS
//
//  Created by 신얀 on 2/3/25.
//

import Foundation
import SwiftUI

// MARK: - ChatNavigationState

final class ChatNavigationState: ObservableObject {
    @Published var selectedChatRoomId: Int64? 
    @Published var shouldNavigateToChatRoom: Bool = false

    static let shared = ChatNavigationState()

    func navigateToChatRoom(id: Int64) {
        DispatchQueue.main.async {
            self.selectedChatRoomId = id
            self.shouldNavigateToChatRoom = true
        }
    }

    func resetNavigation() {
        selectedChatRoomId = nil
        shouldNavigateToChatRoom = false
    }
}
