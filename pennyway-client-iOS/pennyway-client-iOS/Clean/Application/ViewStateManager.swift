//
//  ViewManager.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/22/24.
//

import SwiftUI

// MARK: - CurrentViewType

enum CurrentViewType {
    case activeApp // MainChatView와 ChatView를 제외한 모든 뷰
    case activeChatRoomList // MainChatView일 경우(추천 채팅 제외)
    case activeChatRoom // ChatView일 경우
    case inactive
    case background
}

// MARK: - ViewStateManager

class ViewStateManager: ObservableObject {
    /// 현재 활성화된 뷰 타입을 저장하는 변수 (기본값: activeApp)
    @Published var currentViewType: CurrentViewType = .activeApp
    /// 현재 표시되고 있는 뷰를 저장하는 변수
    @Published var currentView: AnyView?

    /// 현재 뷰 설정 함수
    /// - parameter view: 새로운 뷰를 받아와서 currentView에 설정함
    /// - parameter selectedTab: 선택된 탭, nil일 수 있음
    func setCurrentView(_ view: some View, selectedTab: Int? = nil) {
        currentView = AnyView(view)

        if view is MainChatView {
            if selectedTab == 1 {
                currentViewType = .activeChatRoomList
                Log.info("[ViewStateManager] View state: activeChatRoomList")
            } else {
                currentViewType = .activeApp
                Log.info("[ViewStateManager] View state: activeApp")
            }
        } else if view is ChatView {
            currentViewType = .activeChatRoom
            Log.info("[ViewStateManager] View state: activeChatRoom")
        } else {
            currentViewType = .activeApp
            Log.info("[ViewStateManager] View state: activeApp")
        }
    }

    /// 앱의 화면 상태(ScenePhase)에 따른 처리
    /// - parameter phase: 현재의 화면 상태를 전달받아 처리
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
