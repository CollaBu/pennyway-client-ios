//
//  DefaultJoinChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/6/24.
//

import Foundation

class DefaultJoinChatRoomRepository: JoinChatRoomRepository {
    private let cdnUrl = "https://cdn.dev.pennyway.co.kr/"

    func joinChatRoom(chatRoomId: Int64, password: String, completion: @escaping (Result<ChatRoom, any Error>) -> Void) {
        let joinChatRoomDto = JoinChatRoomRequestDto(password: password)

        ChatAlamofire.shared.joinChatRoom(chatRoomId, joinChatRoomDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(MakeChatRoomResponseDto.self, from: responseData)
                        // 응답 DTO를 Model로 매핑
//                        let chatRoom = response.data.chatRoom { chatRoomDetail in
//                            return ChatRoomDetail.toChatRoom(dto: chatRoomDetail, cdnUrl: self.cdnUrl)
//                        }
                        let chatRoom = ChatRoomDetail.toChatRoom(dto: response.data.chatRoom, cdnUrl: self.cdnUrl)

                        Log.debug("[DefaultGetChatRoomRepository]: 내 채팅 조회 api 성공: \(response)")
                        completion(.success(chatRoom))
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
