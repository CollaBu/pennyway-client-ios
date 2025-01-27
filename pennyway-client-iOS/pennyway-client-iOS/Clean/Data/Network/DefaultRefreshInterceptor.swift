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

    func handle(completion: @escaping (Bool) -> Void) {
        socketAuthHandler.handle(completion: completion)
    }
}

// MARK: - DefaultRefreshSocketInterceptor

class DefaultRefreshSocketInterceptor: SocketRefreshInterceptor {
    private let socketAuthRepository: DefaultSocketAuthRepository

    init(socketAuthRepository: DefaultSocketAuthRepository) {
        self.socketAuthRepository = socketAuthRepository
    }

    func handle() {
        socketAuthRepository.handle()
    }
}
