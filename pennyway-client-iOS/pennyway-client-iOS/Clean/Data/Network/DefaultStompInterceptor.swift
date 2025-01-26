//
//  DefaultStompInterceptor.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/23/25.
//

import Foundation

// MARK: - DefaultStompInterceptor

class DefaultStompInterceptor: StompInterceptor {
    private let socketAuthHandler: SocketAuthHandler

    init(socketAuthHandler: SocketAuthHandler) {
        self.socketAuthHandler = socketAuthHandler
    }

    func handle(completion _: @escaping (Result<String, any Error>) -> Void) {
        socketAuthHandler.retry()
    }
}

// MARK: - AuthEvent

enum AuthEvent {
    case refreshStart
    case refreshComplete(token: String)
    case authUpdateComplete
}

// MARK: - DefaultRefreshSocketInterceptor

class DefaultRefreshSocketInterceptor: SocketRefreshInterceptor {
    private let socketAuthRepository: SocketAuthRepository

    init(socketAuthRepository: SocketAuthRepository) {
        self.socketAuthRepository = socketAuthRepository
    }

    func handle() {
        socketAuthRepository.handleTokenRefreshComplete()
    }
}
