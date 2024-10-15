//
//  DefaultChatStompRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/15/24.
//

import Foundation

class DefaultChatStompRepository: ChatStompRepository {
    func getChatServer(completion: @escaping (Result<String, Error>) -> Void) {
        ChatAlamofire.shared.getChatServer { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetChatServerResponseDto.self, from: responseData)
                        Log.debug("[DefaultChatServerRepository] chat 서버 받기 성공: \(response)")
                        completion(.success(response.data.chatServerUrl))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
