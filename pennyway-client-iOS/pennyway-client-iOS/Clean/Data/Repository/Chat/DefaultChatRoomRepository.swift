//
//  DefaultChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Foundation

class DefaultChatRoomRepository: ChatRoomRepository {
    func getChatRoomDetail(chatRoomId: Int64, completion: @escaping (Result<ChatRoomDetailInfo, Error>) -> Void) {
        ChatRoomAlamofire.shared.getChatRoomDetail(chatRoomId) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetChatRoomDetailResponseDto.self, from: responseData)
                        let chatRoomInfo = GetChatRoomDetailResponseDto.to(dto: response)

                        Log.debug("[DefaultChatRoomRepository]: 채팅 상세 정보 조회 api 성공: \(response)")
                        completion(.success(chatRoomInfo))
                    } catch {
                        Log.fault("Error parsing response JSON: \(error)")
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(.failure(error))
            }
        }
    }

    func getPreviousChat(chatRoomId: Int64, lastMessageId: Int64, completion: @escaping (Result<PreviousMessage, Error>) -> Void) {
        ChatRoomAlamofire.shared.getPreviousChat(chatRoomId, lastMessageId) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetPreviousChatResponseDto.self, from: responseData)
                        let previousMessage = GetPreviousChatResponseDto.to(dto: response)

                        Log.debug("[DefaultChatRoomRepository]: 채팅 상세 정보 조회 api 성공: \(response)")
                        completion(.success(previousMessage))
                    } catch {
                        Log.fault("Error parsing response JSON: \(error)")
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                if let statusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(statusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(.failure(error))
            }
        }
    }
}
