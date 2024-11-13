//
//  DefaultJoinChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/6/24.
//

import Foundation

// MARK: - JoinChatRoomError

enum JoinChatRoomError: Error {
    case invalidPassword // 비밀번호가 일치하지 않는다는 4004 에러
    case other(Error)
}

// MARK: - DefaultJoinChatRoomRepository

class DefaultJoinChatRoomRepository: JoinChatRoomRepository {
    private let cdnUrl = Url.cdnUrl

    func execute(chatRoomId: Int64, password: String, completion: @escaping (Result<ChatRoom, any Error>) -> Void) {
        let joinChatRoomDto = JoinChatRoomRequestDto(password: password.isEmpty ? nil : password)

        ChatAlamofire.shared.joinChatRoom(chatRoomId, joinChatRoomDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(MakeChatRoomResponseDto.self, from: responseData)

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
                    if StatusSpecificError.domainError == .badRequest, StatusSpecificError.code == BadRequestErrorCode.invalidRequest.rawValue {
                        completion(.failure(JoinChatRoomError.invalidPassword))
                    } else {
                        completion(.failure(JoinChatRoomError.other(error)))
                    }
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(.failure(error))
            }
        }
    }
}
