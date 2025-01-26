//
//  StompInterceptor.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/23/25.
//

import Foundation

// MARK: - StompInterceptor

protocol StompInterceptor {
    func handle(completion: @escaping (Result<String, Error>) -> Void)
}

// MARK: - SocketRefreshInterceptor

protocol SocketRefreshInterceptor {
    func handle()
}
