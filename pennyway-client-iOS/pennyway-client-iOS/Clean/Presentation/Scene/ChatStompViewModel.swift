//
//  ChatStompViewModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/16/24.
//

import Combine
import StompClientLib
import SwiftUI

class ChatStompViewModel: ObservableObject {
    private let useCase: ChatStompUseCase
    
    @Published var messages: [Chat] = []
    @Published var isConnected: Bool = false
    
    init(useCase: ChatStompUseCase = DefaultChatStompUseCase(repository: DefaultChatStompRepository(), stompClient: StompClientLib())) {
        self.useCase = useCase
        
        if let defaultUseCase = useCase as? DefaultChatStompUseCase {
            defaultUseCase.$isConnected
                .receive(on: DispatchQueue.main)
                .assign(to: &$isConnected)
            
            defaultUseCase.$messages
                .receive(on: DispatchQueue.main)
                .assign(to: &$messages)
        }
    }
    
    func connect() {
        useCase.connect()
    }
    
    func disconnect() {
        useCase.disconnect()
    }
    
    func sendMessage(roomId: String, content: String) {
        useCase.sendMessage(roomId: roomId, content: content)
    }
}
