//
//  SendChatUseCase.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/7/24.
//

import Foundation

// MARK: - ChatRoomUseCase

protocol SendChatUseCase {
    func sendMessage(message: String, destination: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

// MARK: - DefaultChatRoomUseCase

class DefaultSendChatUseCase: SendChatUseCase {
    private let chatStompService = DefaultChatStompService.shared

    func sendMessage(message: String, destination: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        chatStompService.sendMessage(message: message, destination: destination)
    }
}
