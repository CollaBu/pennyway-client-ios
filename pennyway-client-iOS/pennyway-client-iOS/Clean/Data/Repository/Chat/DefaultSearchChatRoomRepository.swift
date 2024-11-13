//  DefaultSearchChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/2/24.
//
//

import Foundation

class DefaultSearchChatRoomRepository: SearchChatRoomRepository {
    @Published var chatRoomData: [ChatRoom] = [] // 채팅방 데이터 리스트

    private let cdnUrl = Url.cdnUrl
    private var currentPageNumber: Int = 0
    private let pageSize: Int = 10 // 페이지당 채팅방 개수
    private var hasNext = true // 다음 페이지가 있는지 여부
    private var isFetching = false // api실행 중엔 중복호출하지 않도록 방지하는 변수

    func execute(model: SearchChatRoom, completion: @escaping (Result<([ChatRoom], Bool), any Error>) -> Void) {
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
                            Log.debug("No content returned for page \(self.currentPageNumber). Stopping pagination.")
                            self.hasNext = false // 더 이상 페이지가 없으므로 hasNext를 false로 설정
                            completion(.success(([], self.hasNext)))
                            return
                        }

                        Log.debug("currentPageNumber before merge: \(self.currentPageNumber)")

                        // 새 데이터를 병합
                        self.mergeNewChatRooms(newChatRoomData: chatRooms)

                        // 데이터 병합 성공 후 페이지 증가
                        self.currentPageNumber += 1
                        Log.debug("currentPageNumber after merge: \(self.currentPageNumber)")

                        // 다음 페이지가 있는지 여부 업데이트
                        self.hasNext = response.data.chatRoom.hasNext

                        Log.debug("hasNext: \(self.hasNext)")
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

        let existId = Set(chatRoomData.map { $0.id })
        _ = newChatRoomData.filter { !existId.contains($0.id) }

        combinedChatRooms.sort { $0.id > $1.id }
        chatRoomData = combinedChatRooms
    }
}
