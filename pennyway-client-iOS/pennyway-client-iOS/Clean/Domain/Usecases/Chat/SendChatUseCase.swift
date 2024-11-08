//
//  SendChatUseCase.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/7/24.
//

import Foundation

// MARK: - SendChatUseCase

protocol SendChatUseCase {
    func sendMessage(message: String, destination: Int64, contentType: String, completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - DefaultSendChatUseCase

class DefaultSendChatUseCase: SendChatUseCase {
    private let chatStompService = DefaultChatStompService.shared

    func sendMessage(message: String, destination: Int64, contentType: String, completion: @escaping (Result<Void, Error>) -> Void) {
        chatStompService.sendMessage(message: message, destination: destination, contentType: contentType, completion: completion)
    }
}
