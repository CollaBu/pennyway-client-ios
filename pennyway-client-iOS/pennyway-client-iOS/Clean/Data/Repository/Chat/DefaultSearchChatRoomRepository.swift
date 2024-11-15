//  DefaultSearchChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/2/24.
//
//

import Foundation

class DefaultSearchChatRoomRepository: SearchChatRoomRepository {
    @Published var chatRoomData: [ChatRoomDetail] = [] // 채팅방 데이터 리스트
    private var currentPageNumber: Int = 0
    private let cdnUrl = Url.cdnUrl
    private let pageSize: Int = 10 // 페이지당 채팅방 개수
    private var hasNext = true // 다음 페이지가 있는지 여부
    private var isFetching = false // api실행 중엔 중복호출하지 않도록 방지하는 변수

    func execute(model: SearchChatRoom, completion: @escaping (Result<([ChatRoomDetail], Bool), any Error>) -> Void) {
        // target이 비어 있는 경우 API 호출을 하지 않음
        guard !model.target.isEmpty else {
            completion(.success(([], false)))
            return
        }

        guard hasNext, !isFetching else {
            return
        }

        isFetching = true
        let searchChatRoomDto = SearchChatRoomRequestDto(target: model.target, page: currentPageNumber)
        Log.debug("Fetching hasNext: \(hasNext), currentPageNumber: \(currentPageNumber)")

        ChatAlamofire.shared.searchChatRoom(searchChatRoomDto) { result in
            self.isFetching = false
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(SearchChatRoomResponseDto.self, from: responseData)

                        let chatRooms = response.data.chatRoom.contents.map { chatRoomDetail in
                            return ChatRoomDetail.toChatRoom(dto: chatRoomDetail, cdnUrl: self.cdnUrl)
                        }

                        // 콘텐츠가 비어 있는 경우, 더 이상 페이지를 증가시키지 않고 종료
                        guard !chatRooms.isEmpty else {
                            self.hasNext = false
                            completion(.success(([], self.hasNext)))
                            return
                        }

                        // 새 데이터를 병합
                        let mergedChatRooms = self.mergeNewChatRooms(newChatRoomData: response.data.chatRoom.contents)
                        self.currentPageNumber += 1
                        // 다음 페이지가 있는지 여부 업데이트
                        self.hasNext = response.data.chatRoom.hasNext
                        completion(.success((mergedChatRooms, self.hasNext)))
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

    func resetPage() {
        currentPageNumber = 0
        hasNext = true
        isFetching = false
        chatRoomData = []
    }

    /// 무한 스크롤 병합 함수
    private func mergeNewChatRooms(newChatRoomData: [ChatRoomDetail]) -> [ChatRoomDetail] {
        let existingIds = Set(chatRoomData.map { $0.id })
        let uniqueNewChatRooms = newChatRoomData.filter { !existingIds.contains($0.id) }

        // 새로운 데이터 추가
        chatRoomData.append(contentsOf: uniqueNewChatRooms)

        return chatRoomData
    }
}
