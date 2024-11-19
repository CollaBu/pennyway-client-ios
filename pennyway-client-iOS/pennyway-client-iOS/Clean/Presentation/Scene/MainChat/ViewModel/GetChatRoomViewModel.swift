//
//  GetChatRoomViewModel.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/9/24.
//

import Combine
import UIKit

// MARK: - GetChatRoomViewModelInput

protocol GetChatRoomViewModelInput {
    func getChatRoom()
    func searchChatRoom(target: String)
    func initSearch()
    func subscribeToNotifications()
    func unsubscribeFromNotifications()
}

// MARK: - GetChatRoomViewModelOutput

protocol GetChatRoomViewModelOutput {
    var roomData: Observable<[ChatRoomItemModel]> { get set }
    var searchRoomData: Observable<[SearchChatRoomItemModel]> { get set }
    var hasNext: Bool { get }
    var isFetching: Bool { get }
}

// MARK: - GetChatRoomViewModel

protocol GetChatRoomViewModel: GetChatRoomViewModelInput, GetChatRoomViewModelOutput {}

// MARK: - DefaultGetChatRoomViewModel

class DefaultGetChatRoomViewModel: GetChatRoomViewModel {
    @Published var roomData: Observable<[ChatRoomItemModel]>
    @Published var searchRoomData: Observable<[SearchChatRoomItemModel]>

    private let getChatRoomUseCase: GetChatRoomUseCase
    private let searchChatRoomUseCase: SearchChatRoomUseCase
    private var currentPageNumber: Int = 0
    var hasNext: Bool = true // 다음 페이지가 있는지 여부
    var isFetching: Bool = false // API 호출 중인지 여부를 나타내는 플래그
    private var cancellables = Set<AnyCancellable>()

    /// 검색 초기화
    func initSearch() {
        searchRoomData.value = []
        searchChatRoomUseCase.resetPage()
        isFetching = false
        hasNext = true
    }

    func unsubscribeFromNotifications() {
        cancellables.removeAll() // 모든 구독 해제
    }

    init(getChatRoomUseCase: GetChatRoomUseCase, searchChatRoomUseCase: SearchChatRoomUseCase) {
        self.getChatRoomUseCase = getChatRoomUseCase
        self.searchChatRoomUseCase = searchChatRoomUseCase

        roomData = Observable([])
        searchRoomData = Observable([])
    }

    /// NotificationCenter에서 메시지 알림 구독
    func subscribeToNotifications() {
        NotificationCenter.default.publisher(for: .didReceiveMessage)
            .sink { [weak self] notification in
                // 메시지 받은 경우 처리
                if let message = notification.object as? MessageItemModel {
                    if let index = self?.roomData.value.firstIndex(where: { $0.id == message.chatRoomId }) {
                        // 해당 roomData의 lastMassage를 업데이트
                        self?.roomData.value[index].lastMassage = message
                        self?.roomData.value[index].unreadMessageCount += 1
                    }
                }
            }
            .store(in: &cancellables) // 구독 관리
    }

    /// 내 채팅방 조회 요청
    func getChatRoom() {
        getChatRoomUseCase.getChatRoom { [weak self] success, chatRooms in
            DispatchQueue.main.async {
                if success {
                    if let chatRooms = chatRooms {
                        self?.roomData.value = chatRooms.map { chatRoomDetail in
                            return ChatRoomItemModel(
                                id: chatRoomDetail.id,
                                title: chatRoomDetail.title,
                                description: chatRoomDetail.description,
                                backgroundImageUrl: chatRoomDetail.backgroundImageUrl,
                                isPrivate: chatRoomDetail.isPrivate,
                                isAdmin: chatRoomDetail.isAdmin,
                                participantCount: chatRoomDetail.participantCount,
                                lastMassage: chatRoomDetail.lastMassage,
                                unreadMessageCount: chatRoomDetail.unreadMessageCount
                            )
                        }
                        Log.debug("[ChatViewModel]: 내 채팅방 조회 성공")
                    }
                } else {
                    Log.debug("[ChatViewModel]: 내 채팅방 조회 실패")
                }
            }
        }
    }

    /// 채팅 검색 조회 요청
    func searchChatRoom(target: String) {
        guard !isFetching, hasNext else {
            return
        }
        isFetching = true

        searchChatRoomUseCase.execute(target: target, page: currentPageNumber) { [weak self] success, chatRooms, hasNext in
            DispatchQueue.main.async {
                self?.isFetching = false

                if success {
                    if let chatRooms = chatRooms {
                        self?.searchRoomData.value = chatRooms
                        self?.hasNext = hasNext
                        Log.debug("[ChatViewModel]: 채팅방 검색 성공")
                    }
                }
            }
        }
    }
}
