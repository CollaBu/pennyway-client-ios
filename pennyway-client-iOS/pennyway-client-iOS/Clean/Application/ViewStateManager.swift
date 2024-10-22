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

    /// 현재 뷰 확인
    func setCurrentView(_ view: some View) {
        currentView = AnyView(view)

        if view is MainChatView {
            currentViewType = .activeChatRoomList
            Log.info("[ViewStateManager] View state: activeChatRoomList")
        } else if view is ChatView {
            currentViewType = .activeChatRoom
            Log.info("[ViewStateManager] View state: activeChatRoom")
        } else {
            currentViewType = .activeApp
            Log.info("[ViewStateManager] View state: activeApp")
        }
    }

    /// 화면 상태 확인
    func setScenePhase(_ phase: ScenePhase) {
        switch phase {
        case .active:
            currentViewType = .activeApp
            Log.info("[ViewStateManager - setScenePhase] View state: activeApp")
        case .inactive:
            currentViewType = .inactive
            Log.info("[ViewStateManager - setScenePhase] View state: inactive")
        case .background:
            currentViewType = .background
            Log.info("[ViewStateManager - setScenePhase] View state: background")
        @unknown default:
            currentViewType = .activeApp
        }
    }
}
