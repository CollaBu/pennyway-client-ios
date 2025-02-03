//
//  HandleDeepLinkUseCase.swift
//  pennyway-client-iOS
//
//  Created by 신얀 on 2/2/25.
//

import Foundation

// MARK: - HandleDeepLinkUseCase

/// 딥링크의 데이터를 분석 및 처리
protocol HandleDeepLinkUseCase {
//    func execute(deepLink: DeepLink)
}

// MARK: - DefaultHandleDeepLinkUseCase

class DefaultHandleDeepLinkUseCase: HandleDeepLinkUseCase {
    private let coordinator: DeepLinkCoordinator

    init(coordinator: DeepLinkCoordinator) {
        self.coordinator = coordinator
    }

//    func execute(deepLink: DeepLink) {
//        coordinator.handleDeepLink(url: deepLink)
//    }
}
