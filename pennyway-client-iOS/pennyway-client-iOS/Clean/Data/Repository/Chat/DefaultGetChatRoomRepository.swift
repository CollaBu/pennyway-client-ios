//
//  DefaultGetChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/24/24.
//

import Foundation

class DefaultGetChatRoomRepository: GetChatRoomRepository {
    func getChatRoom(completion: @escaping (Result<[ChatRoom], any Error>) -> Void) {
        ChatAlamofire.shared.getChatRoom { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(MakeChatRoomResponseDto.self, from: responseData)

                        // 응답 DTO를 Model로 매핑
                        let chatRooms = response.data.chatRooms.map { chatRoomDetail in
                            return ChatRoom(
                                id: chatRoomDetail.id,
                                title: chatRoomDetail.title,
                                description: chatRoomDetail.description,
                                background_image_url: chatRoomDetail.backgroundImageUrl,
                                isPrivate: chatRoomDetail.isPrivate,
                                isAdmin: chatRoomDetail.isAdmin,
                                participantCount: chatRoomDetail.participantCount,
                                createdAt: chatRoomDetail.createdAt ?? ""
                            )
                        }

                        Log.debug("[DefaultGetChatRoomRepository]: 내 채팅 조회 api 성공: \(response)")
                        completion(.success(chatRooms))
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
