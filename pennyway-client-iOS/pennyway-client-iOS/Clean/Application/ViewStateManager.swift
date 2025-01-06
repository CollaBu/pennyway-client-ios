//
//  ViewManager.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/22/24.
//

import SwiftUI

// MARK: - CurrentViewType

enum CurrentViewType: String {
    case activeNonChat = "ACTIVE_APP" // MainChatView와 ChatView를 제외한 모든 뷰
    case activeChatRoomCell = "ACTIVE_CHAT_ROOM_LIST" // MainChatView일 경우(추천 채팅 제외)
    case activeChatRoom = "ACTIVE_CHAT_ROOM" // ChatView일 경우
    case inactive = "INACTIVE"
    case background = "BACKGROUND"
}

// MARK: - ViewStateManager

class ViewStateManager: ObservableObject {
    private let chatStompService = DefaultChatStompService.shared
    private var lastViewType: CurrentViewType = .activeNonChat
    private var lastChatRoomId: Int64? = nil

    /// 현재 활성화된 뷰 타입을 저장하는 변수 (기본값: activeApp)
    var currentViewType: CurrentViewType = .activeNonChat

    /// 현재 표시되고 있는 뷰를 저장하는 변수
    var currentView: AnyView?

    /// 현재 뷰 설정 함수
    /// - Parameters:
    ///   - view: 새로운 뷰를 받아와서 currentView에 설정
    ///   - selectedTab: 선택된 탭 (기본값: nil)
    ///   - chatRoomId: 선택된 채팅방 ID (기본값: nil)
    func setCurrentView(_ view: some View, selectedTab: Int? = nil, chatRoomId: Int64? = nil) {
        currentView = AnyView(view)

        if view is ChatCellView {
            if selectedTab == 1 { // 내 채팅인 경우
                currentViewType = .activeChatRoomCell
                Log.info("[ViewStateManager] View state: activeChatRoomCell")
            } else { // 추천 채팅인 경우
                currentViewType = .activeNonChat
                Log.info("[ViewStateManager] View state: activeNonChat")
            }
        } else if view is ChatRoomView {
            currentViewType = .activeChatRoom
            Log.info("[ViewStateManager] View state: activeChatRoom")
        } else if view is LoginView {
            currentViewType = .inactive
            Log.info("[ViewStateManager] View state: inactive")
        } else {
            currentViewType = .activeNonChat
            Log.info("[ViewStateManager] View state: activeNonChat")
        }

        lastViewType = currentViewType
        lastChatRoomId = chatRoomId
        chatStompService.sendViewState(status: currentViewType.rawValue, chatRoomId: chatRoomId)
    }

    /// 앱의 화면 상태(ScenePhase)에 따른 처리
    /// - parameter phase: 현재의 화면 상태를 전달받아 처리
    func setScenePhase(_ phase: ScenePhase) {
        switch phase {
        case .active:
            currentViewType = lastViewType
            Log.info("[ViewStateManager - setScenePhase] View state: \(currentViewType.rawValue)")
        case .inactive, .background:
            currentViewType = .background
            Log.info("[ViewStateManager - setScenePhase] View state: background")
        @unknown default:
            currentViewType = .activeNonChat
        }

        chatStompService.sendViewState(status: currentViewType.rawValue, chatRoomId: currentViewType == .activeChatRoom ? lastChatRoomId : nil)
    }
}
