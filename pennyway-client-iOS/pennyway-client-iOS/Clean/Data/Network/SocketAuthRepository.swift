//
//  SocketAuthRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/23/25.
//

import Foundation

final class SocketAuthRepository: SocketRefreshInterceptor {
    private let stompClient: CustomStompClient

    init(
        stompClient: CustomStompClient = .shared
    ) {
        self.stompClient = stompClient
    }

    /// TokenRefreshHandler로부터 AT를 전달받아 인증 갱신 요청
    func handle() {
        stompClient.sendRefreshToken()
        Log.info("📤 [Send RefreshToken]")
    }
}
