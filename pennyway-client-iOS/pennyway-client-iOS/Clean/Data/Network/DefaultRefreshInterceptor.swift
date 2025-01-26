//
//  DefaultRefreshInterceptor.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/23/25.
//

import Foundation

// MARK: - DefaultRefreshInterceptor

class DefaultRefreshInterceptor: RefreshInterceptor {
    private let socketAuthHandler: SocketAuthHandler

    init(socketAuthHandler: SocketAuthHandler) {
        self.socketAuthHandler = socketAuthHandler
    }

    func handle(completion _: @escaping (Result<String, any Error>) -> Void) {
        socketAuthHandler.retry()
    }
}

// MARK: - DefaultRefreshSocketInterceptor

class DefaultRefreshSocketInterceptor: SocketRefreshInterceptor {
    private let socketAuthRepository: SocketAuthRepository

    init(socketAuthRepository: SocketAuthRepository) {
        self.socketAuthRepository = socketAuthRepository
    }

    func handle() {
        socketAuthRepository.handle()
    }
}
