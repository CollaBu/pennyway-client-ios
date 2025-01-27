//
//  RefreshInterceptor.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/23/25.
//

import Foundation

// MARK: - RefreshInterceptor

protocol RefreshInterceptor {
    func handle(completion: @escaping (Bool) -> Void)
}

// MARK: - SocketRefreshInterceptor

protocol SocketRefreshInterceptor {
    func handle()
}
