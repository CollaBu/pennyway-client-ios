//
//  DeepLinkHandler.swift
//  pennyway-client-iOS
//
//  Created by 신얀 on 2/2/25.
//

import Foundation

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
        
//        useCase.execute(deepLink: deepLink)
    }
    
//    static let shared = DeepLinkHandler()
//    
//    // 딥링크 URL을 받아서 처리하는 함수
//    func handleDeepLink(url: URL) {
//        // URL에서 파라미터 추출
//        guard let parameters = url.queryParameters, let chatRoomId = parameters["chatRoomId"] else {
//            Log.fault("⚠️ chatRoomId is missing in URL")
//            return
//        }
//        
//        // 파라미터를 통해 화면 이동 처리
//        navigateToChatRoom(chatRoomId: chatRoomId)
//    }
//    
//    // chatRoomId에 해당하는 채팅방으로 이동하는 처리 함수
//    private func navigateToChatRoom(chatRoomId: String) {
//        NotificationCenter.default.post(name: .didReceiveDeepLink, object: chatRoomId)
//    }
}
