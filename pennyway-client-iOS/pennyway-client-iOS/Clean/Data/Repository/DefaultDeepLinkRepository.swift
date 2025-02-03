//
//  DefaultDeepLinkRepository.swift
//  pennyway-client-iOS
//
//  Created by 신얀 on 2/2/25.
//

import Foundation

final class DefaultDeepLinkRepository: DeepLinkRepository {
    func parse(url: URL) -> DeepLink? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host
        else {
            return nil
        }

        var parameters: [String: String] = [:]
        components.queryItems?.forEach { item in
            parameters[item.name] = item.value
        }

        // URL 스킴에 따른 타겟 매핑
        let target: DeepLinkTarget?
        switch host {
        case "chatRoom":
            if let chatRoomId = parameters["id"] {
                target = .chatRoom(chatRoomId: chatRoomId)
            } else {
                target = nil
            }
        default:
            target = nil
        }

        guard let target = target else {
            return nil
        }
        return DeepLink(target: target, parameters: parameters)
    }
}
