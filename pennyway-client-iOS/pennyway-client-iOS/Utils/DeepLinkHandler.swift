//
//  DeepLinkHandler.swift
//  pennyway-client-iOS
//
//  Created by 신얀 on 2/2/25.
//

import Foundation

/// Handler
final class DeepLinkHandler {
    private let repository: DeepLinkRepository
    private let useCase: HandleDeepLinkUseCase
    
    init(repository: DeepLinkRepository, useCase: HandleDeepLinkUseCase) {
        self.repository = repository
        self.useCase = useCase
    }
    
    func handle(url: URL) {
        guard let deepLink = repository.parse(url: url) else {
            // 에러 처리
            return
        }
        
        useCase.execute(deepLink: deepLink)
    }
}
