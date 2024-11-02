//
//  DefaultSearchChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/2/24.
//
//
import Foundation

class DefaultSearchChatRoomRepository: SearchChatRoomRepository {
    private let cdnUrl = "https://cdn.dev.pennyway.co.kr/"

    func execute(model: SearchChatRoom, completion: @escaping (Result<[ChatRoom], any Error>) -> Void) {
        let searchChatRoomDto = SearchChatRoomRequestDto(target: model.target, page: model.page)

        ChatAlamofire.shared.searchChatRoom(searchChatRoomDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(SearchChatRoomResponseDto.self, from: responseData)

                        // 응답 DTO를 Model로 매핑
                        let chatRooms = response.data.chatRooms.contents.map { chatRoomDetail in
                            let completeBackgroundImageUrl = self.createFullURL(with: self.cdnUrl, pathComponent: chatRoomDetail.backgroundImageUrl)

                            return ChatRoom(
                                id: chatRoomDetail.id,
                                title: chatRoomDetail.title,
                                description: chatRoomDetail.description,
                                background_image_url: completeBackgroundImageUrl,
                                isPrivate: chatRoomDetail.isPrivate,
                                isAdmin: chatRoomDetail.isAdmin,
                                participantCount: chatRoomDetail.participantCount,
                                createdAt: chatRoomDetail.createdAt ?? ""
                            )
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

    /// 기본 URL과 pathComponent를 결합하는 함수
    private func createFullURL(with cdnUrl: String, pathComponent: String) -> String {
        guard let url = URL(string: cdnUrl)?.appendingPathComponent(pathComponent) else {
            return cdnUrl // 기본 URL 반환 (잘못된 경우)
        }
        return url.absoluteString
    }
}
