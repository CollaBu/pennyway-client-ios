//
//  DefaultChatServerRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/15/24.
//

import Foundation

class DefaultChatServerRepository: ChatServerRepository {
    func getChatServer(completion: @escaping (Result<Void, Error>) -> Void) {
        ChatAlamofire.shared.getChatServer { result in
            switch result {
            case let .success(responseData):
                // 응답 데이터 디코딩
                if let data = responseData {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Chat server successfully retrieved.")
                        print("Response: \(responseString)")
                    } else {
                        print("Failed to convert response data to string.")
                    }
                } else {
                    print("Received nil response data.")
                }
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
