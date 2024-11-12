//  DefaultSearchChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/2/24.
//
//

import Foundation

class DefaultSearchChatRoomRepository: SearchChatRoomRepository {
    @Published var chatRoomData: [ChatRoom] = [] // 채팅방 데이터 리스트

    private let cdnUrl = "https://cdn.dev.pennyway.co.kr/"
    private var currentPageNumber: Int = 0
    private let pageSize: Int = 10 // 페이지당 채팅방 개수
    private var hasNext = true // 다음 페이지가 있는지 여부

    func execute(model: SearchChatRoom, completion: @escaping (Result<([ChatRoom], Bool), any Error>) -> Void) {
        guard hasNext else {
            return
        }

        let searchChatRoomDto = SearchChatRoomRequestDto(target: model.target, page: currentPageNumber)
        Log.debug("Fetching hasNext: \(hasNext)")

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

                        self.mergeNewChatRooms(newChatRoomData: chatRooms)
                        self.currentPageNumber += 1 // 페이지 번호 증가
                        self.hasNext = response.data.chatRoom.hasNext

                        Log.debug("hasNext: \(self.hasNext)")

                        Log.debug("[SearchChatRoomResponseDto]: 채팅방 검색 api 성공: \(response)")
                        completion(.success((chatRooms, self.hasNext)))
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

    /// 무한 스크롤 병합 함수
    private func mergeNewChatRooms(newChatRoomData: [ChatRoom]) {
        var combinedChatRooms = chatRoomData

        for newChatRoom in newChatRoomData {
            if !combinedChatRooms.contains(where: { $0.id == newChatRoom.id }) {
                combinedChatRooms.append(newChatRoom)
            }
        }

        combinedChatRooms.sort { $0.id > $1.id }
        chatRoomData = combinedChatRooms
    }
}
