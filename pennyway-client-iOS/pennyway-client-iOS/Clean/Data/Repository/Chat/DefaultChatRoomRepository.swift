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
                    if let responseString = String(data: responseData, encoding: .utf8) {
                        Log.debug("[DefaultChatRoomRepository]: 채팅 상세 정보 조회 api 응답: \(responseString)")
                    }
                    do {
                        let response = try JSONDecoder().decode(GetChatRoomDetailResponseDto.self, from: responseData)

                        if let responseString = String(data: responseData, encoding: .utf8) {
                            Log.debug("[DefaultChatRoomRepository]: 채팅 상세 정보 조회 api 응답: \(responseString)")
                        }
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
}
