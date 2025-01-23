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
        let destination = "/pub/auth.refresh"
        let receiptId = "refresh-receipt-\(UUID().uuidString)"
        let headers = [
            "Authorization": "Bearer \(KeychainHelper.loadAccessToken() ?? "")",
            "content-type": "application/json",
            "receipt": receiptId
        ]
        
        stompClient.sendMessage(
            message: "",
            destination: destination,
            headers: headers,
            receipt: receiptId
        )
        
        Log.info("📤 [Send RefreshToken]")
    }
}
