//
//  SocketAuthRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/23/25.
//

import Foundation

final class SocketAuthRepository {
    private let stompClient: CustomStompClient
    private let notificationQueue: NotificationQueue

    init(
        stompClient: CustomStompClient = .shared,
        notificationQueue: NotificationQueue = .default
    ) {
        self.stompClient = stompClient
        self.notificationQueue = notificationQueue
    }

    /// TokenRefreshHandler로부터 AT를 전달받아 인증 갱신 요청
    func updateAuthentication() {
        stompClient.sendRefreshToken()
        Log.info("📤 [Send RefreshToken]")
    }
}
