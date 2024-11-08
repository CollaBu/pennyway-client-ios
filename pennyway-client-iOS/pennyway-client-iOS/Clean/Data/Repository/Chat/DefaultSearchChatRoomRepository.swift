//
//  DefaultSearchChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/2/24.
//
//
import Foundation

class DefaultSearchChatRoomRepository: SearchChatRoomRepository {
    private let cdnUrl = Url.cdnUrl

    func execute(model: SearchChatRoom, completion: @escaping (Result<[ChatRoom], any Error>) -> Void) {
        let searchChatRoomDto = SearchChatRoomRequestDto(target: model.target, page: model.page)

        ChatAlamofire.shared.searchChatRoom(searchChatRoomDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(SearchChatRoomResponseDto.self, from: responseData)

                        // 응답 DTO를 Model로 매핑
                        let chatRooms = response.data.chatRoom.contents.map { chatRoomDetail in
                            return ChatRoomDetail.toChatRoom(dto: chatRoomDetail, cdnUrl: self.cdnUrl)
                        }
                        Log.debug("[SearchChatRoomResponseDto]: 채팅방 검색 api 성공: \(response)")
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
