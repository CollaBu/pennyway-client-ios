//
//  DefaultChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Foundation

class DefaultChatRoomRepository: ChatRoomRepository {
    /// 채팅 상세 정보 조회
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

    /// 이전 채팅 내역 조회
    func getPreviousChat(chatRoomId: Int64, lastMessageId: Int64, completion: @escaping (Result<PreviousMessage, Error>) -> Void) {
        let dto = GetPreviousChatRequestDto(lastMessageId: lastMessageId)

        ChatRoomAlamofire.shared.getPreviousChat(chatRoomId, dto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetPreviousChatResponseDto.self, from: responseData)
                        let previousMessage = GetPreviousChatResponseDto.to(dto: response)

                        Log.debug("[DefaultChatRoomRepository]: 이전 채팅 내역 조회 api 성공: \(response)")
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

    /// 채팅 멤버 조회
    func getChatMembers(chatRoomId: Int64, ids: [Int64], completion: @escaping (Result<[ChatMember], any Error>) -> Void) {
        let dto = GetChatMembersRequestDto(ids: ids)

        ChatRoomAlamofire.shared.getChatMembers(chatRoomId, dto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetChatMembersReponseDto.self, from: responseData)
                        let members = GetChatMembersReponseDto.to(dto: response)

                        Log.debug("[DefaultChatRoomRepository]: 채팅 멤버 조회 api 성공: \(response)")
                        completion(.success(members))
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

    func deleteChatRoom(chatRoomId: Int64, chatMemberId: Int64, completion: @escaping (Bool) -> Void) {
        ChatRoomAlamofire.shared.deleteChatRoom(chatRoomId, chatMemberId) { result in
            switch result {
            case let .success(data):
                Log.debug("[DefaultChatRoomRepository]: 채팅방 나가기 성공")
                completion(true)
            case let .failure(error):
                if let statusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(statusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(false)
            }
        }
    }
}
