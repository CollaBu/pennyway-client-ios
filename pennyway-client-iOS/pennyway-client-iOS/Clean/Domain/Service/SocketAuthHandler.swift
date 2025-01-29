//
//  SocketAuthHandler.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/23/25.
//

import Foundation

// MARK: - SocketAuthHandler

final class SocketAuthHandler: RefreshInterceptor {
    // MARK: - Properties
   
    static let shared = SocketAuthHandler()
    private let notificationQueue: NotificationQueue
    private var isProcessing = false
   
    // MARK: - Initialize
   
    private init(
        notificationQueue: NotificationQueue = .default
    ) {
        self.notificationQueue = notificationQueue
       
        setupNotifications()
    }
   
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
    private func setupNotifications() {
        // 소켓 인증 완료 이벤트 구독
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAuthComplete),
            name: .socketAuthComplete,
            object: nil
        )
       
        // TokenRefreshHandler의 토큰 갱신 실 패 이벤트 구독
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTokenRefreshFailure),
            name: .tokenRefreshFailure,
            object: nil
        )
    }
   
    // MARK: - Public Methods
   
    func handle(completion: @escaping (Bool) -> Void) {
        guard !isProcessing else {
            completion(false)
            return
        } // 진행 중이면, 나머지 요청은 버림.
        
        Log.debug("[SocketAuthHandler] - retry")
       
        isProcessing = true
        notificationQueue.enqueue(
            Notification(name: .socketAuthStart),
            postingStyle: .asap
        )
       
        TokenRefreshHandler.shared.refreshSync { _, _ in
            completion(true)
        }
    }
   
    @objc private func handleAuthComplete() {
        Log.debug("[SocketAuthHandler] - handleAuthComplete")
        
        isProcessing = false
        notificationQueue.enqueue(
            Notification(name: .socketAuthUnlock),
            postingStyle: .asap
        )
    }
   
    @objc private func handleTokenRefreshFailure() {
        // 필요한 에러 핸들링. isProcessing 상태는 실패해도 반드시 바꿔줘야 함.
        
        Log.debug("[SocketAuthHandler] - handleTokenRefreshFailure")
   
        isProcessing = false
        notificationQueue.enqueue(
            Notification(name: .socketAuthUnlock),
            postingStyle: .asap
        )
    }
}
