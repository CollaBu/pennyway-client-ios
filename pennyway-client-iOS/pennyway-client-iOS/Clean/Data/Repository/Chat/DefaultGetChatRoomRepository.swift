//
//  DefaultGetChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/24/24.
//

import Foundation

class DefaultGetChatRoomRepository: GetChatRoomRepository {
    func getChatRoom(completion: @escaping (Result<ChatRoomData, any Error>) -> Void) {
        ChatAlamofire.shared.getChatRoom { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(MakeChatRoomResponseDto.self, from: responseData)
                        let chatRoomDetail = response.data.chatRoom
                                                
                        // 받아온 응답 DTO를 Model로 변환
                        let ChatRoom = ChatRoom(id: chatRoomDetail.id, title: chatRoomDetail.title, description: chatRoomDetail.description, background_image_url: chatRoomDetail.backgroundImageUrl, isPrivate: chatRoomDetail.isPrivate, isAdmin: chatRoomDetail.isAdmin, participateCount: chatRoomDetail.participantCount)
                        
                        Log.debug("[DefaultGetChatRoomRepository]: 내 채팅 조회 api 성공: \(response)")
                        completion(.success(ChatRoom))
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
