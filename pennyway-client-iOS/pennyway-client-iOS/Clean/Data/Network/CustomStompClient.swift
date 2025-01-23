//
//  CustomStompClient.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/23/25.
//

import Foundation
import StompClientLib

// MARK: - CustomStompClient

/// 의존성 주입해주는 곳에서 생성
final class CustomStompClient {
    // MARK: - Properties
   
    static let shared = CustomStompClient()
    private let stompClient: StompClientLib
    private let interceptor: StompInterceptor // retry를 위한 interceptor, 배열로 하고 싶으면 그렇게 하면 됨.
    private let notificationQueue: NotificationQueue // 원래 여기서 처리하면 안 되는데, `serverDidSendReceipt`에 이유를 적음.
   
    // MARK: - Initialize
   
    private init(
        interceptor: StompInterceptor = DefaultStompInterceptor(socketAuthHandler: SocketAuthHandler.shared),
        notificationQueue _: NotificationQueue = .default
    ) {
        stompClient = StompClientLib()
        self.interceptor = interceptor
    }
}

// MARK: StompClientLibDelegate

extension CustomStompClient: StompClientLibDelegate {
    func stompClientDidConnect(client _: StompClientLib!) {
        Log.info("[Socket] Connected")
    }
   
    func stompClientDidDisconnect(client _: StompClientLib!) {
        Log.info("[Socket] Disconnected")
    }
   
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody _: String?, withHeader _: [String: String]?, withDestination _: String) {
        // error queue에서 401 메시지 수신 시 interceptor 호출
        if let body = jsonBody as? [String: Any],
           let code = body["code"] as? String,
           code == "4011"
        {
            interceptor.handle { result in
                Log.debug("[Socket] Retry result: \(result)")
            }
        }
    }
   
    func serverDidSendReceipt(client _: StompClientLib!, withReceiptId receiptId: String) {
        if receiptId.hasPrefix("refresh-receipt-") {
            notificationQueue.enqueue( // 원래 SocketAuthRepository가 처리해야 하는데, 순환 참조 걸려서 임시로 처리.
                Notification(name: .socketAuthComplete),
                postingStyle: .asap
            )
        }
    }
   
    func serverDidSendError(client _: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        Log.error("[Socket] Error - description: \(description), message: \(message ?? "")")
    }
   
    func serverDidSendPing() {
        Log.debug("[Socket] Ping received")
    }
}

// MARK: - Public Methods

extension CustomStompClient {
    func connect(url: String, headers: [String: String]) {
        let request = NSURLRequest(url: URL(string: url)!)
        stompClient.openSocketWithURLRequest(
            request: request,
            delegate: self,
            connectionHeaders: headers
        )
    }
   
    func disconnect() {
        stompClient.disconnect()
    }
   
    func subscribe(destination: String, withHeader: [String: String]) {
        stompClient.subscribeWithHeader(
            destination: destination,
            withHeader: withHeader
        )
    }
   
    func sendMessage(message: String, destination: String, headers: [String: String], receipt: String? = nil) {
        stompClient.sendMessage(
            message: message,
            toDestination: destination,
            withHeaders: headers,
            withReceipt: receipt
        )
    }
}

// MARK: - Notification Extension

extension Notification.Name {
    static let socketAuthComplete = Notification.Name("socket-auth-complete")
}
