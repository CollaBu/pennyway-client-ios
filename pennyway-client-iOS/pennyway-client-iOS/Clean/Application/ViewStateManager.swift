//
//  ViewManager.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/22/24.
//

import SwiftUI

// MARK: - CurrentViewType

enum CurrentViewType {
    case activeApp
    case activeChatRoomList
    case activeChatRoom
    case inactive
    case background
}

// MARK: - ViewStateManager

class ViewStateManager: ObservableObject {
    @Published var currentViewType: CurrentViewType = .activeApp
    @Published var currentView: AnyView?

    func setCurrentView(_ view: some View) {
        currentView = AnyView(view)

        if view is MainChatView {
            currentViewType = .activeChatRoomList
        } else if view is ChatView {
            currentViewType = .activeChatRoom
        } else {
            currentViewType = .activeApp
        }
    }

    func setScenePhase(_ phase: ScenePhase) {
        switch phase {
        case .active:
            currentViewType = .activeApp
            Log.info("[ViewStateManager] View state: active")
        case .inactive:
            currentViewType = .inactive
            Log.info("[ViewStateManager] View state: inactive")
        case .background:
            currentViewType = .background
            Log.info("[ViewStateManager] View state: background")
        @unknown default:
            currentViewType = .activeApp
        }
    }
}
