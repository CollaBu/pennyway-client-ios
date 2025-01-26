//
//  SocketAuthRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/23/25.
//

import Foundation

final class SocketAuthRepository: SocketRefreshInterceptor {
    private let stompClient: CustomStompClient
    private let notificationQueue: NotificationQueue
    
    init(
        stompClient: CustomStompClient = .shared,
        notificationQueue: NotificationQueue = .default
    ) {
        self.stompClient = stompClient
        self.notificationQueue = notificationQueue
//        setupNotifications()
        
        Log.debug("?????")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
//    private func setupNotifications() {
//        // TokenRefreshHandler의 토큰 갱신 완료 이벤트 구독
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(handleTokenRefreshComplete),
//            name: .tokenRefreshComplete,
//            object: nil
//        )
//    }
    
    ///    /// TokenRefreshHandler로부터 AT를 전달받아 인증 갱신 요청
    ///    @objc private func handleTokenRefreshComplete() {
    ///        stompClient.sendRefreshToken()
    ///        Log.info("📤 [Send RefreshToken]")
    ///    }
//    
    func handle() {
        stompClient.sendRefreshToken()
        Log.info("📤 [Send RefreshToken]")
    }

    /// TokenRefreshHandler로부터 AT를 전달받아 인증 갱신 요청
    func handleTokenRefreshComplete() {
        stompClient.sendRefreshToken()
        Log.info("📤 [Send RefreshToken]")
    }
    
    //    /// TokenRefreshHandler로부터 AT를 전달받아 인증 갱신 요청
    //    func updateAuthentication() {
    //        stompClient.sendRefreshToken()
    //        Log.info("📤 [Send RefreshToken]")
    //    }
}
