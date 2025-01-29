//
//  HandleDeepLinkUseCase.swift
//  pennyway-client-iOS
//
//  Created by 신얀 on 1/20/25.
//

import Foundation

// MARK: - HandleDeepLinkUseCase

/// 딥링크의 데이터를 분석 및 처리
protocol HandleDeepLinkUseCase {
    func execute(deepLink: DeepLink)
}

// MARK: - DefaultHandleDeepLinkUseCase

class DefaultHandleDeepLinkUseCase: HandleDeepLinkUseCase {
    func execute(deepLink: DeepLink) {
        switch deepLink.target {
        //        case .userProfile(let userId):
        //            // 사용자 프로필 화면으로 이동
        //            break
        case let .chatRoom(chatRoomId):
            // 채팅방 화면으로 이동
            break
        }
    }
}
